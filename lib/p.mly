%{
let wloc ((startpos : Lexing.position), (endpos : Lexing.position)) v =
  Loc.
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

%token EOF UNIT LPAREN RPAREN APP FUN RARROW
%token <float> NUMBER
%token <string> ID
%token <string> STRING

/* cf. https://ptival.github.io/2017/05/16/parser-generators-and-function-application/ */
%nonassoc UNIT NUMBER ID STRING LPAREN FUN
%nonassoc APP
%nonassoc RARROW

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
  | FUN params=list(Pat) RARROW body=Expr { wloc $sloc @@ Expr.Fun (params, body) }
  | LPAREN e=Expr RPAREN { e }
  | l=Expr r=Expr %prec APP { wloc $sloc @@ Expr.Apply (l, r) }

Pat :
  | id=ID { wloc $sloc @@ Pat.Var id }
