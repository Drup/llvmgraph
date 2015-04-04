PACKAGE=llvmgraph

case "$OCAML_VERSION" in
4.01.0) ppa=avsm/ocaml41+opam12 ;;
4.02.0) ppa=avsm/ocaml42+opam12 ;;
*) echo Unknown $OCAML_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa

echo "yes" | sudo add-apt-repository 'deb http://ppa.launchpad.net/ubuntu-toolchain-r/test/ubuntu precise main'
echo "yes" | sudo add-apt-repository 'deb http://llvm.org/apt/precise/ llvm-toolchain-precise-3.6 main'
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key | sudo apt-key add -

sudo apt-get update -qq
sudo apt-get install -qq -y ocaml ocaml-native-compilers camlp4-extra opam llvm-3.6-dev clang-3.6

export OPAMYES=1
echo OCaml version
ocaml -version
echo OPAM info
opam config report

opam init
eval `opam config env`


opam pin add --verbose -n ${PACKAGE} .

opam install -t -d --verbose ${PACKAGE}
opam remove --verbose ${PACKAGE}
