
type stack = int list
(* type 'a stack = 'a list *)

type result = 
    | Val of int
    | OK of stack
    | Empty
    | Full

let stack_make ()   = []
let stack_push s a  = OK (a::s)
let stack_peek s    = if s = [] then Empty else Val (List.hd s)
let stack_pop  s    = if s = [] then Empty else OK (List.tl s)
let stack_empty s   = (s = [])
let stack_full s    = false

(*
let stack_peek s = 
    match s with
       | [] -> Empty
       | a::s' -> Val a
*)

(*
let stack_pop s = 
    match s with
       | [] -> Empty
       | a::s' -> OK s'
*)

let () = 
    let s = stack_make() in
    let res = stack_peek s in
    assert(res = Empty)

let () = assert(stack_peek (stack_make()) = Empty)
let () = assert(stack_pop (stack_make()) = Empty)

let () =
	let s = stack_make() in
    let res = stack_push s 10 in
    assert(res = OK [10])

let () =
	let s = stack_make() in
    let res = stack_push s 10 in
    match res with
        | OK s' -> assert((stack_pop s') = OK [])
        | _ -> assert(false)

let () =
    assert((stack_push (stack_make()) 10) = OK [10])
