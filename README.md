llvmgraph
===============

Ocamlgraph overlay for llvm

The overlay allows you to read and walk (but not write) the control flow graph of an llvm function using the same interface than an ocamlgraph. In particular, read-only ocamlgraph's algorithm can be applied.

It is also possible to use the Map functor and another graph structure to translate an llvm control flow graph to another graph.
