(* Our goal is to apply the k-coloring algorithm on some llvm control flow graph and to create a dot output correctly colored.*)

(* First, a bit of prelude. *)
open Llvmgraph

(* A bit of boilerplate to read a bitcode. *)
let read_bitcode file =
  let ctx = Llvm.create_context () in
  let mem = Llvm.MemoryBuffer.of_file file in
  let m = Llvm_bitreader.parse_bitcode ctx mem in
  Llvm.MemoryBuffer.dispose mem ;
  m

(* We will do 3-coloring! Let's define the rgba representations for them. *)
let to_color h v =
  match Coloring.H.find h v with
    | 0 -> 0x0000FF55l
    | 1 -> 0x00FF0055l
    | 2 -> 0xFF000055l
    | _ -> 0l

let () =
  (* Read the bitcode given in the CLI! *)
  let m = read_bitcode Sys.argv.(1) in

  (* Open the file where we will put the dot output! *)
  let chout = open_out Sys.argv.(2) in

  (* We 3-colors each functions in the bitcode. *)
  Llvm.iter_functions (fun llf ->
    (* Coloring is a pre-applied functor defined [module Coloring = Graph.Coloring.Make(G)].
       We use the ocamlgraph implementation directly!
    *)
    let h = Coloring.coloring llf 3 in

    (* Define a module for dot output using ocamlgraph's Dot functor. *)
    let module Dot = Graph.Graphviz.Dot (struct
        include G

        (* Boiler-plate for dot definition. *)
        let graph_attributes _ = []
        let default_vertex_attributes _ = []
        let get_subgraph _ = None
        let default_edge_attributes _ = []
        let edge_attributes e =
          let user = Llvm.user (G.E.label e) in
          let s = Printf.sprintf "user: %s" (Llvm.string_of_llvalue user) in
          [`Label s]

        (* Print the definition of each basic block nicely. *)
        let vertex_name v =
          (* Fetch a string representation of a basic block. *)
          let s = Llvm.(string_of_llvalue (value_of_block v)) in
          (* Work around graphviz' crappyness, don't look. *)
          Str.global_replace (Str.regexp "\n") "\\l" (Printf.sprintf "\"%s\"" s)
        (* Make the output pretty! *)
        let vertex_attributes v = [
          `Fontname "monospace";
          `Shape `Record ;
          `Style `Filled ;
          `FillcolorWithTransparency (to_color h v) ;
        ]

      end)
    in

    (* Output the dot. *)
    Dot.output_graph chout llf
  ) m ;

  (* Clean up the mess before leaving. *)
  close_out chout
