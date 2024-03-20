{
    open Parser;;
    exception InvalidToken of char ;;
}

let digit = ['0' - '9']
let non_zero_digit = ['1' - '9']
let num = '0' | (non_zero_digit digit*)
let alpha_num = ['A' - 'Z' 'a' - 'z' '0' - '9' '_']
let var = ['A' - 'Z' '_'] (alpha_num*)
let cons = ['a' - 'z'] (alpha_num*) | ("'" [^ '\"']* "'") | ("\"" [^ '\"']* "\"")

rule token = parse
  | [' ' '\t' '\n']+        { token lexbuf }
  | "fail"                  { FAIL }
  | var as v                { VAR(v) }
  | cons as c               { CONS(c) }
  | num as n                { CONS(n) }
  | '('                     { LPAREN }
  | ')'                     { RPAREN }
  | '['                     { LBRACKET }
  | ']'                     { RBRACKET }
  | '|'                     { PIPE }
  | ','                     { COMMA }
  | '.'                     { ENDL }
  | '!'                     { CUT }
  | ":-"                    { COND }
  | "\\+"                   { NOT }
  | "\\="                   { NOT_EQ }
  | '='                     { EQ }
  | eof                     { EOF }
  | _ as s                  { raise (InvalidToken s) }
