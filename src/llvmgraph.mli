(** Read only ocamlgraph interface for the control-flow-graph of llvm functions. *)

(** Graph of an llvm function.

    Warning : {!map_vertex} is not implemented! *)
module G : Graph.Sig.G
  with type t = Llvm.llvalue
   and type V.t = Llvm.llbasicblock
   and type E.label = unit

(** Mapping from Llvm's control flow graph to another graph. *)
module Map (B : Graph.Builder.S) : sig

  val map :
    vertex:(G.vertex -> B.G.vertex) ->
    label:(G.edge -> B.G.E.label) ->
    ?src:(G.E.vertex -> B.G.E.vertex) ->
    ?dst:(G.E.vertex -> B.G.E.vertex) ->
    G.t -> (G.vertex -> B.G.vertex) * B.G.t

end
