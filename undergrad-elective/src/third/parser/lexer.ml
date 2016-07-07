open Core
open Core.Std
open StringLabels

let isdigit c = (c >= '0' && c <= '9')
let isalpha c = ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'))
let alnum   c = (isalpha c) || (isdigit c)
let iswhitespace c = List.mem [' '; '\t'; '\n'] c
let iscomma c = (c = ',')

let id x = x

type source = {
   text: string;
   mutable cursor: int;
}

type token =  | Comma | Op of string | Num of int

let read_source path = { text = In_channel.read_all path; cursor = 0; }
let peek (src: source) = src.text.[src.cursor]
let advance (src: source) (n: int) = src.cursor <- src.cursor + n
let substr text start last = StringLabels.sub text start (last-start)

let eat_white_space (src: source) = 
    let len = String.length src.text and
      start = src.cursor in
      while start < len && iswhitespace (peek src) do
            advance src 1
      done

let eat_number (src: source) = 
    let len = String.length src.text and
	  start = src.cursor in
	  while start < len && isdigit (peek src) do
        advance src 1
	  done;
      Num (int_of_string (substr src.text start src.cursor))


let eat_ident (src: source) = 
    let len = String.length src.text and
      start = src.cursor in
        while start < len && isalpha (peek src) do
          advance src 1
      	done;
        Op (id (substr src.text start src.cursor))


let lex source = 
	eat_white_space source;
    let c = peek source in
    if (iscomma c) then  (advance source 1; Comma)
    else if isdigit c then eat_number source
    else if isalpha c then eat_ident source
    else assert(false);;




