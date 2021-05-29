(* eval.ml *)

open Syntax ;;

(* Some helper functions for dealing the environment *)

(* List.assoc_opt *)
let rec lookup var env =
  match env with
  | [] -> failwith @@ "unbound variable '" ^ var ^ "'"
  | (var2, val2)::t ->
     if var = var2 then val2
     else lookup var t


let rec update var value env =
  match env with
  | [] -> [(var, value)]
  | (var2, val2) as h::t ->
     if var = var2 then (var, value)::t
     else h::update var value t

		    
(* The evaluator *)
		    
(* eval_a_exp : a_exp -> env -> int *)
let rec eval_a_exp a_exp env =
  match a_exp with
  | IntLit num -> num
  | Plus (a_exp1, a_exp2) -> 
     let value1 = eval_a_exp a_exp1 env in
     let value2 = eval_a_exp a_exp2 env in
     value1 + value2
  | Times (a_exp1, a_exp2) -> 
     let value1 = eval_a_exp a_exp1 env in
     let value2 = eval_a_exp a_exp2 env in
     value1 * value2
  | Var var ->
     lookup var env

(* eval_b_exp : b_exp -> env -> bol *)
let eval_b_exp b_exp env =
  match b_exp with
  | BoolLit bool -> bool
  | Lt (a_exp1, a_exp2) ->  
     let value1 = eval_a_exp a_exp1 env in
     let value2 = eval_a_exp a_exp2 env in
     value1 < value2
		     
(* eval_command : command -> env -> env *)
let rec eval_command command env =
  match command with
  | Skip -> env
  | Seq (command1, command2) ->
     let new_env = eval_command command1 env in
     eval_command command2 new_env
  | While (b_exp, command) ->
     if eval_b_exp b_exp env
     then eval_command (Seq (command, While (b_exp, command))) env
     else env
  | Assign (var, a_exp)->
     let value = eval_a_exp a_exp env in
     update var value env
	    
