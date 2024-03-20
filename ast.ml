type term =
    | Variable of string
    | Constant of string
    | Node of string * (term list)
type atomic_formula = AtomicFormula of string * (term list)
type head = Head of atomic_formula
type body = Body of atomic_formula list
type clause = Fact of head | Rule of head * body
type program = clause list

let rec string_of_term = function
  | Variable v -> "VARIABLE " ^ v
  | Constant c -> "CONSTANT " ^ c
  | Node (f, args) ->
    "SYMBOL " ^ f ^ "(" ^ String.concat ", " (List.map string_of_term args) ^ ")"

let string_of_atomic_formula = function
  | AtomicFormula (pred, args) ->
    "ATOMIC FORMULA { " ^ pred ^ "(" ^ String.concat ", " (List.map string_of_term args) ^ ") }"

let rec string_of_body = function
  | [] -> ""
  | [a] -> string_of_atomic_formula a
  | a :: rest ->
    (string_of_atomic_formula a) ^ ",\n" ^ string_of_body rest

let string_of_head = function
  | Head a -> string_of_atomic_formula a

let string_of_clause = function
  | Fact head -> "FACT { " ^ string_of_head head ^ " }.\n"
  | Rule (head, Body atom_list) ->
    "RULE { " ^ (string_of_head head) ^ " :- \n" ^ string_of_body atom_list ^ " }.\n"

let rec string_of_program = function
  | [] -> ""
  | [c] -> string_of_clause c
  | c :: rest -> string_of_clause c ^ "\n" ^ string_of_program rest

let print_program program =
  print_endline (string_of_program program)
