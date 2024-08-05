let parse_lex lex =
  let format_error fmt =
    let pos = lex.Lexing.lex_start_p in
    Printf.ksprintf
      (fun s -> Error s)
      ("%s:%d:%d: " ^^ fmt) pos.pos_fname pos.pos_lnum
      (pos.pos_cnum - pos.pos_bol + 1)
  in

  match P.toplevel L.main lex with
  | exception L.Unexpected_char c -> format_error "lexer: unexpected char: %c" c
  | exception P.Error -> format_error "parser: syntax error"
  | x -> Ok x

let parse_string ?(filename = "") str =
  let lex = Lexing.from_string ~with_positions:true str in
  Lexing.set_filename lex filename;
  parse_lex lex

let parse_file file_path =
  let ic = open_in_bin file_path in
  Fun.protect ~finally:(fun () -> close_in ic) @@ fun () ->
  let lex = Lexing.from_channel ic in
  Lexing.set_filename lex file_path;
  parse_lex lex
