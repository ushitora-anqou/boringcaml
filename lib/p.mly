%{
let wloc ((startpos : Lexing.position), (endpos : Lexing.position)) v =
  Expr.
    {
      v;
      loc =
        {
          fname = startpos.pos_fname;
          ran = Some {
            startpos = {
              line = startpos.pos_lnum;
              column = startpos.pos_cnum - startpos.pos_bol;
            };
            endpos = {
              line = endpos.pos_lnum;
              column = endpos.pos_cnum - endpos.pos_bol;
            };
          };
        };
    }
%}

%token EOF UNIT LPAREN RPAREN APP
%token <float> NUMBER
%token <string> ID
%token <string> STRING

/* cf. https://ptival.github.io/2017/05/16/parser-generators-and-function-application/ */
%nonassoc UNIT NUMBER ID STRING LPAREN /* list ALL other tokens that start an expr */
%nonassoc APP

%start toplevel
%type <Expr.t> toplevel
%%

toplevel :
  | e=Expr EOF { e }

Expr :
  | UNIT { wloc $sloc Expr.Unit }
  | id=ID { wloc $sloc @@ Expr.Var id }
  | s=STRING {
    wloc $sloc @@ Expr.String s
  }
  | i=NUMBER {
    wloc $sloc @@ Expr.Number i
  }
  | LPAREN e=Expr RPAREN { e }
  | l=Expr r=Expr %prec APP { wloc $sloc @@ Expr.Apply (l, r) }
