llvmgraph [![Build Status](https://travis-ci.org/Drup/llvmgraph.svg?branch=master)](https://travis-ci.org/Drup/llvmgraph)
===============

Ocamlgraph overlay for llvm

The overlay allows you to read and walk (but not write) the control flow graph of an llvm function using the same interface than an ocamlgraph. In particular, read-only ocamlgraph's algorithm can be applied.

It is also possible to use the Map functor and another graph structure to translate an llvm control flow graph to another graph.

All Ocamlgraph functors that work on read-only graph have been pre-applied, to ease usage of the library.

See [the interface](src/llvmgraph.mli) for more details.

## Dependencies ##

- llvm
- ocamlgraph
- str for the [colordot test](test/colordot.ml).

## Examples and How-to ##

The [test](test) folder may be consulted to find some interesting uses of this library. In particular, the [colordot example](test/colordot.ml) is annotated with detailed explanations.

Here is the result on [`example.c`](test/example.c):
![colordot.dot](http://i.imgur.com/VahGMoP.png)

Other examples are very welcome.
