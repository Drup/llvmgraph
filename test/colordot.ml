open Graph
open Llvmgraph

let to_color h v =
  match Coloring.H.find h v with
    | 0 -> 0x0000FF55l
    | 1 -> 0x00FF0055l
    | 2 -> 0xFF000055l
    | _ -> 0l

let () =
  let ctx = Llvm.create_context () in
  let mem = Llvm.MemoryBuffer.of_file Sys.argv.(1) in
  let m = Llvm_bitreader.parse_bitcode ctx mem in
  Llvm.MemoryBuffer.dispose mem ;

  let chout = open_out Sys.argv.(2) in
  Llvm.iter_functions (fun llf ->
    let h = Coloring.coloring llf 3 in
    let module Dot = Graphviz.Dot (struct
        include G

        let graph_attributes _ = []
        let default_vertex_attributes _ = []

        let vertex_name v =
          let s = Llvm.(string_of_llvalue (value_of_block v)) in
          Str.global_replace (Str.regexp "\n") "\\l" (Printf.sprintf "\"%s\"" s)
        let vertex_attributes v = [
          `Fontname "monospace";
          `Shape `Record ;
          `Style `Filled ;
          `FillcolorWithTransparency (to_color h v) ;
        ]
        let get_subgraph _ = None
        let default_edge_attributes _ = []
        let edge_attributes _ = []

      end)
    in
    Dot.output_graph chout llf
  ) m ;
  close_out chout
