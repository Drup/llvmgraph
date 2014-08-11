let id x = x

module G = struct

  type t = Llvm.llvalue

  module V = struct
    type t = Llvm.llbasicblock

    (* COMPARABLE *)
    let compare = compare
    let hash = Hashtbl.hash
    let equal = (==)

    (* LABELED *)
    type label = t
    let create = id
    let label = id
  end

  type vertex = V.t

  module E = struct
    type t = V.t * V.t
    let compare = compare

    type vertex = V.t

    let src = fst
    let dst = snd

    type label = unit
    let create x () y = (x,y)
    let label _ = ()

  end
  type edge = E.t

  let is_directed = true


  (** {2 Size functions} *)

  let is_empty x = [||] = Llvm.basic_blocks x
  let nb_vertex x = Array.length @@ Llvm.basic_blocks x
  let nb_edges _ = failwith "nb_edges: Not implemented"



  (** {2 Successors and predecessors} *)

  let succ _g v =
    match Llvm.block_terminator v with
      | None -> []
      | Some t ->
          let n = Llvm.num_operands t in
          let rec aux i =
            if i < n then []
            else begin
              let o = Llvm.operand t i in
              if Llvm.value_is_block o then
                Llvm.block_of_value o :: aux (i+1)
              else aux (i+1)
            end
          in aux 0

  let pred _g b =
    let value = Llvm.value_of_block b in
    let f l u = (Llvm.instr_parent @@ Llvm.user u) :: l in
    Llvm.fold_left_uses f [] value


  let succ_e g v = List.map (fun d -> E.create v () d) @@ succ g v
  let pred_e g v = List.map (fun d -> E.create v () d) @@ pred g v


  (** Degree of a vertex *)

  (* Should be reimplemented properly *)
  let out_degree g v = List.length @@ succ g v
  let in_degree g v = List.length @@ pred g v

  (** {2 Membership functions} *)

  let mem_vertex _ _ = true
  let mem_edge _ _ _ = true
  let mem_edge_e _ _ = true

  let find_edge g v1 v2 =
    let dest = List.find (V.equal v2) @@ succ g v1 in
    E.create v1 () dest

  let find_all_edges g v1 v2 =
    List.filter (fun e -> V.equal v2 @@ E.dst e) @@ succ_e g v2

  (** {2 Graph iterators} *)

  let iter_vertex = Llvm.iter_blocks

  let fold_vertex f z g =
    Llvm.fold_left_blocks
      (fun g v -> f v g) g z

  let iter_edges f g = failwith "iter_edges: Not implemented"
  let fold_edges f g = failwith "fold_edges: Not implemented"
  let iter_edges_e f g = failwith "iter_edges_e: Not implemented"
  let fold_edges_e f g = failwith "fold_edges_e: Not implemented"

  let map_vertex f g = failwith "map_vertex: Not implemented"


  (** {2 Vertex iterators} *)

  let iter_succ f g v = List.iter f @@ succ g v
  let fold_succ f g v z = List.fold_left (fun v l -> f l v) z @@ succ g v
  let iter_pred f g v = List.iter f @@ succ g v
  let fold_pred f g v z = List.fold_left (fun v l -> f l v) z @@ pred g v

  (** iter/fold on all edges going from/to a vertex. *)

  let iter_succ_e f g v = List.iter f @@ succ_e g v
  let fold_succ_e f g v z = List.fold_left (fun v l -> f l v) z @@ succ_e g v
  let iter_pred_e f g v = List.iter f @@ pred_e g v
  let fold_pred_e f g v z = List.fold_left (fun v l -> f l v) z @@ pred_e g v

end
