
type stack = int list
(* type 'a stack = 'a list *)

type result = 
    | Val of int
    | OK of stack
    | Empty
    | Full

let make ()   = []
let push s a  = OK (a::s)
let peek s    = if s = [] then Empty else Val (List.hd s)
let pop  s    = if s = [] then Empty else OK (List.tl s)
let empty s   = (s = [])
let full s    = false

(*
let peek s = 
    match s with
       | [] -> Empty
       | a::s' -> Val a
*)

(*
let pop s = 
    match s with
       | [] -> Empty
       | a::s' -> OK s'
*)
