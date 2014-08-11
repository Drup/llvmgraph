

let read_file ~ctx file =
  let mem = Llvm.MemoryBuffer.of_file file in
  let m = Llvm_bitreader.parse_bitcode ctx mem in
  Llvm.MemoryBuffer.dispose mem ;
  m
