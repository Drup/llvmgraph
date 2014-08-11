
module G : Graph.Sig.G
  with type V.t = Llvm.llbasicblock

module Map (B : Graph.Builder.S) : sig

  val map :
    vertex:(G.vertex -> B.G.vertex) ->
    label:(G.edge -> B.G.E.label) ->
    G.t -> (G.vertex -> B.G.vertex) * B.G.t

end
