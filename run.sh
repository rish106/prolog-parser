#!/bin/sh

ocamlc -c ./ast.ml \
    && ocamlyacc ./parser.mly \
    && ocamlc -c ./parser.mli \
    && ocamlc -c ./parser.ml \
    && ocamllex ./lexer.mll > /dev/null \
    && ocamlc -c ./lexer.ml \
    && ocamlc -c ./main.ml \
    && ocamlc -o main ./lexer.cmo ./parser.cmo ./ast.cmo ./main.cmo \
    && ./main "$1"
