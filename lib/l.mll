{
  exception Unexpected_char of char

  let string_literal_buffer = Buffer.create 0

  let add_unicode_char_to_buffer s =
    let v = "0x" ^ (String.sub s 2 (String.length s - 2)) |> int_of_string in
    let e = Uutf.encoder `UTF_8 (`Buffer string_literal_buffer) in
    Uutf.encode e (`Uchar (Uchar.of_int v)) |> ignore;
    Uutf.encode e `End |> ignore;
    ()

  let char_for_backslash = function
    | 'b' -> '\008'
    | 'f' -> '\012'
    | 'n' -> '\010'
    | 'r' -> '\013'
    | 't' -> '\009'
    | c -> c
}

let whitespace = [' ' '\t']
let newline = '\n' | '\r' | "\r\n"
let hexadecimal_unicode_escape =
  "\\u"
  ['0'-'9' 'a'-'f' 'A'-'F']
  ['0'-'9' 'a'-'f' 'A'-'F']
  ['0'-'9' 'a'-'f' 'A'-'F']
  ['0'-'9' 'a'-'f' 'A'-'F']

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
| ('0' | ['1'-'9'] ['0'-'9']*) ('.' ['0'-'9']+)? (['e' 'E'] ['-' '+']? ['0'-'9']+)? {
  P.NUMBER (Lexing.lexeme lexbuf |> float_of_string)
}
| '"' {
  let original_lex_start_p = lexbuf.lex_start_p in
  Buffer.clear string_literal_buffer;
  double_quoted_string lexbuf;
  lexbuf.lex_start_p <- original_lex_start_p;
  P.STRING (Buffer.contents string_literal_buffer)
}
| eof {
  P.EOF
}
| _ as c {
  raise (Unexpected_char c)
}


and double_quoted_string = parse
| '"' {
  ()
}
| hexadecimal_unicode_escape {
  add_unicode_char_to_buffer (Lexing.lexeme lexbuf);
  double_quoted_string lexbuf
}
| '\\' ([^ 'u'] as c) {
  Buffer.add_char string_literal_buffer (char_for_backslash c);
  double_quoted_string lexbuf
}
| newline as s {
  Lexing.new_line lexbuf;
  Buffer.add_string string_literal_buffer s;
  double_quoted_string lexbuf
}
| _ as c {
  Buffer.add_char string_literal_buffer c;
  double_quoted_string lexbuf
}
