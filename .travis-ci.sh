PACKAGE=llvmgraph

OPAM_VERSION=1.1.0
case "$OCAML_VERSION,$OPAM_VERSION" in
4.01.0,1.1.0) ppa=avsm/ocaml41+opam11 ;;
4.02.0,1.1.0) ppa=avsm/ocaml42+opam11 ;;
*) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
export OPAMYES=1
echo OCaml version
ocaml -version
echo OPAM versions
opam --version
opam --git-version

opam init
eval `opam config env`

opam pin --verbose ${PACKAGE} .

opam install -t -d --verbose ${PACKAGE}
opam remove --verbose ${PACKAGE}
