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

%token EOF UNIT

%start toplevel
%type <Expr.t> toplevel
%%

toplevel :
  | e=Expr EOF { e }

Expr :
  | UNIT { wloc $sloc Expr.Unit }
