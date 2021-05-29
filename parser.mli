type token =
  | VAR of (string)
  | INT of (int)
  | PLUS
  | MINUS
  | ASTERISK
  | LT
  | SEMICOL
  | ASSIGN
  | LPAREN
  | RPAREN
  | LCBRA
  | RCBRA
  | TRUE
  | FALSE
  | WHILE
  | SKIP
  | EOF

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.command
