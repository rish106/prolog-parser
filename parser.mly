%{
    open Ast ;;
%}

%token <string> VAR CONS
%token LPAREN RPAREN LBRACKET RBRACKET COMMA ENDL COND NOT CUT FAIL EOF PIPE EQ NOT_EQ

%left COMMA
%nonassoc PIPE
%nonassoc ENDL

%type <Ast.program> program
%start program
%%

program:
    EOF                                             { [] }
  | clause_list EOF                                 { $1 }
;

clause_list:
    clause                                          { [$1] }
  | clause clause_list                              { ($1)::$2 }
;

clause:
    atomic_formula ENDL                             { Fact(Head($1)) }
  | atomic_formula COND atomic_formula_list ENDL    { Rule(Head($1), Body($3)) }
;

atomic_formula_list:
    atomic_formula                                  { [$1] }
  | atomic_formula COMMA atomic_formula_list        { ($1)::$3 }
;

atomic_formula:
  | CONS                                            { AtomicFormula($1, []) }
  | NOT CONS                                        { AtomicFormula("NOT " ^ $2, []) }
  | CONS LPAREN term_list RPAREN                    { AtomicFormula($1, $3) }
  | NOT CONS LPAREN term_list RPAREN                { AtomicFormula("NOT " ^ $2, $4) }
  | CUT                                             { AtomicFormula("_cut", []) }
  | NOT CUT                                         { AtomicFormula("NOT " ^ "_cut", []) }
  | FAIL                                            { AtomicFormula("_fail", []) }
  | NOT FAIL                                        { AtomicFormula("NOT " ^ "_fail", []) }
  | term EQ term                                    { AtomicFormula("_eq", [$1; $3]) }
  | term NOT_EQ term                                { AtomicFormula("_not_eq", [$1; $3]) }
;

term_list:
    term                                            { [$1] }
  | term COMMA term_list                            { ($1)::$3 }
;

term:
    LPAREN term RPAREN                              { $2 }
  | VAR                                             { Variable($1) }
  | CONS                                            { Constant($1) }
  | CONS LPAREN term_list RPAREN                    { Node($1, $3) }
  | list                                            { $1 }
;

list:
    LBRACKET RBRACKET                               { Node("_empty_list", []) }
  | LBRACKET list_body RBRACKET                     { $2 }
;

list_body:
    term                                            { Node("_list", [$1; Node("_empty_list", [])]) }
  | term COMMA list_body                            { Node("_list", [$1; $3]) }
  | term PIPE term                                  { Node("_list", [$1; $3]) }
;
