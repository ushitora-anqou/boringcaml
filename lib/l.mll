{
  exception Unexpected_char of char
}

let whitespace = [' ' '\t']
let newline = '\n' | '\r' | "\r\n"

rule main = parse
| whitespace+ {
  main lexbuf
}
| newline {
  Lexing.new_line lexbuf;
  main lexbuf
}
| "()" {
  P.UNIT
}
| eof {
  P.EOF
}
| _ as c {
  raise (Unexpected_char c)
}
