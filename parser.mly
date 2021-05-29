// Parser
     
%{
  open Syntax
%}

%token <string> VAR  // x, y, abc, ...
%token <int> INT     // 0, 1, 2, ...

// operators
%token PLUS     // '+'
%token MINUS    // '-'
%token ASTERISK // '*'
%token LT       // '<'
%token SEMICOL  // ';'
%token ASSIGN    // ":="

// Parentheses
%token LPAREN   // '('
%token RPAREN   // ')'
%token LCBRA    // '{'
%token RCBRA    // '}'

// reserved names
%token TRUE     // "true"
%token FALSE    // "false"
%token WHILE    // "while"
%token SKIP    // "skip"

// End of file
%token EOF 

// Operator associativity
%left SEMICOL
%nonassoc WHILE ASSIGN 
%nonassoc LT
%left PLUS
%left ASTERISK
%nonassoc UNARY
%nonassoc VAR INT TRUE FALSE LCBRA LPAREN SKIP

%start main
%type <Syntax.command> main

%%

// Main part must end with EOF (End Of File)
main:
  | command EOF
    { $1 }
;

// Arithmetic expression
a_exp:
  | VAR
    { Var $1 }
    
  | INT
    { IntLit $1 }

  // Unary minus -i
  | MINUS INT %prec UNARY
    { IntLit (- $2) }
  
  // e1 + e2
  | a_exp PLUS a_exp
    { Plus ($1, $3) }
  
  // e1 * e2
  | a_exp ASTERISK a_exp
    { Times ($1, $3) }
  
  // Parentheses
  | LPAREN a_exp RPAREN
    { $2 }
;

// Boolean expression
b_exp:
  | TRUE
    { BoolLit true }
    
  | FALSE
    { BoolLit false }
  
  // e1 < e2
  | a_exp LT a_exp
    { Lt ($1, $3) }    
;

// Command
command:
  | SKIP
    { Skip }
    
  // Assignment
  | VAR ASSIGN a_exp
    { Assign ($1, $3) }
  
  // command1; command2
  | command SEMICOL command
    { Seq ($1, $3) }
    
  // while (b_exp) command
  | WHILE LPAREN b_exp RPAREN command
    { While ($3, $5) }
  
  // { command }
  | LCBRA command RCBRA { $2 }
  
  | error
    { 
      let message =
        Printf.sprintf 
          "parse error near characters %d-%d"
          (Parsing.symbol_start ())
	        (Parsing.symbol_end ())
	    in
	    failwith message
	  }
;

