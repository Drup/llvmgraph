(** Read only ocamlgraph interface for the control-flow-graph of llvm functions. *)

open Graph

(** Graph of an llvm function.

    Warning : {!map_vertex} is not implemented! *)
module G : sig
  include Sig.G
    with type t = Llvm.llvalue
     and type V.t = Llvm.llbasicblock
     and type E.label = unit

  module Ordered_label : Sig.ORDERED_TYPE with type t = E.label

  module Weight : sig
    type t = int
    type label = E.label
    type edge = E.t
    val compare : t -> t -> t
    val zero : t
    val add : t -> t -> t

    (** Constant weight, is always 1. *)
    val weight : 'a -> t
  end

end

(** Mapping from Llvm's control flow graph to another graph. *)
module Map (B : Builder.S) : sig

  val map :
    vertex:(G.vertex -> B.G.vertex) ->
    label:(G.edge -> B.G.E.label) ->
    ?src:(G.E.vertex -> B.G.E.vertex) ->
    ?dst:(G.E.vertex -> B.G.E.vertex) ->
    G.t -> (G.vertex -> B.G.vertex) * B.G.t

end

(** {2 Pre-applied functors} *)

module Oper : sig
  module Choose : module type of Oper.Choose(G)
  module Neighbourhood : module type of Oper.Neighbourhood(G)
end

module Component : module type of Components.Make(G)

module Path : sig

  module Dijkstra : module type of Path.Dijkstra(G)(G.Weight)

end

module Traverse : sig

  module Dfs : module type of Traverse.Dfs(G)
  module Bfs : module type of Traverse.Bfs(G)

end

module Coloring : module type of Coloring.Make(G)

module Topological : module type of Topological.Make(G)

module Kruskal : module type of Kruskal.Make(G)(G.Ordered_label)

module Prim : module type of Prim.Make(G)(G.Weight)

module Leaderlist : module type of Leaderlist.Make(G)

(** Do not compute the Dom graph, it will fail.
    Using {!compute_all} is fine, as long as you don't use the dom_graph closure.
*)
module Dominator :
  module type of Dominator.Make(struct
    include G
    let create ?size:_ _ = assert false
    let add_edge _ = assert false
  end)
