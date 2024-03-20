open Ast

let print_program_from_file filename =
  let channel = open_in filename in
  let lexbuf = Lexing.from_channel channel in
  while true do
    let result = Parser.program Lexer.token lexbuf in
    match result with
      | [] -> exit 0;
      | _ -> print_program result;
    flush stdout
  done

let () =
  if Array.length Sys.argv < 2 then
    Printf.printf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    print_program_from_file filename
