(* main.ml *)

open Syntax ;;
open Eval ;;

(* parse : string -> command *)
let parse str = 
  Parser.main Lexer.token 
    (Lexing.from_string str)

(* "X := 4; Y := 1; Z := 0; while (Z < X) { Y := 2 * Y; Z := Z + 1 }" *)
let run str = 
  eval_command (parse str) []


