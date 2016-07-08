
open Core
open Core.Std
open StringLabels

module Lexer : sig
  type source
  type token = | Comma | Op of string | Num of int | Error of (string * int) | EOF

  val init_source : string -> source
  val lex : source -> token
end = struct 
  type source = {
    text: string;
    mutable cursor: int;
    mutable line: int;
  }

  type token = | Comma | Op of string | Num of int | Error of (string * int) | EOF
  type state = | End | Pos of int

  let isdigit c = (c >= '0' && c <= '9')
  let isalpha c = ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
  let iscomma c = (c = ',')
  let iswhitespace c = List.mem [' '; '\t'; '\n'] c
  let isnewline c = c = '\n'

  type init_source = string -> source
  let init_source path   = { text = In_channel.read_all path; cursor = 0; line = 1; }
  let eof (src: source)  = (src.cursor >= (String.length src.text))
  let peek_char (src: source) = src.text.[src.cursor]
  let advance_cursor ?(n=1) src = src.cursor <- src.cursor + n
  let make_lexeme text start last = StringLabels.sub text ~pos:start ~len:(last - start)

  type eat_white_space = source -> state
  let eat_white_space src = 
        while not(eof src) && iswhitespace (peek_char src) do
          if (isnewline (peek_char src)) then src.line <- src.line + 1;
          advance_cursor src;
        done;
        if (eof src) then End else Pos src.line

  type eat_comma = source -> token
  let eat_comma src = advance_cursor src; Comma

  type scan_token = source -> (char->bool) -> (string->token) -> token
  let scan_token src pred ctor = 
      let start = src.cursor in
        while not(eof src) && pred (peek_char src) do
          advance_cursor src;
        done;
        ctor (make_lexeme src.text start src.cursor)

  type eat_number = source -> token
  let eat_number src = scan_token src isdigit (fun str -> Num (int_of_string str))

  type eat_ident = source -> token
  let eat_ident src = scan_token src isalpha (fun str -> Op str)

  type lex = source -> token
  let lex source = 
  	  match eat_white_space source with
  	  | Pos _  ->
        let c = peek_char source in
        if (iscomma c)    then eat_comma source
        else if isdigit c then eat_number source
        else if isalpha c then eat_ident source
        else (
          advance_cursor source;
          let msg = "Lexical error: invalid character - " ^ (String.make 1 c) in
          Error (msg, source.line)
        )
      | End -> EOF

end