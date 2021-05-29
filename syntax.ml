(* syntax.ml *)

(* Arithmetic expression *)
type a_exp = 
  | Var of string         (* variable e.g. x *)
  | IntLit of int         (* integer literal e.g. 17 *)
  | Plus of a_exp * a_exp     (* e + e *)
  | Times of a_exp * a_exp    (* e * e *)

(* Boolean expression *)
type b_exp =
  | BoolLit of bool
  | Lt of a_exp * a_exp       (* e < e *)

(* Command *)
type command =
  | Skip                     
  | Assign of string * a_exp   (* assignment e.g. x := 1 + 2 * y *)
  | Seq of command * command   (* sequence e.g. x := 2; y := x + 1 *)
  | While of b_exp * command   (* loop e.g. while (1 < x) { x := x + 1 } *)
		  
type env = (string * int) list (* environment e.g. [("x", 1); ("y", 2)]*)
