(*
Write a recursive Ocaml function 'iterate_apply​' that takes two arguments: 
a function argument named 'f' and a list named 'lst'. The recursion stops 
when 'lst' is empty. On each recursive step, function 'f' should be applied to 
the element at the head position of 'lst, and the value of applying ‘f​’ must 
be appended to a result list Write a recursive Ocaml function ‘iterate_apply​’ 
that takes two arguments: a function argument named ‘f​’ and a list named 
‘lst’​. The recursion stops when ‘lst​’ is empty. On each recursive step, 
function ‘f​’ should be applied to the element at the head position of ‘lst​’, 
and the value of applying ‘f​’ must be appended to a result list.
*)


let rec iterate_apply f lst =
    match lst with
      | [] -> []
      | x :: lst' -> f x :: iterate_apply f lst' 



(* two sample functions for use in tests below *)
let nop(x) = x
let inc(x:int) : int = x+1

(* these are a few test cases *)
let () = assert(iterate_apply nop [] = [] )
let () = assert(iterate_apply nop [10] = [10] )
let () = assert(iterate_apply nop [10; 20; 30] = [10; 20; 30] )

let () = assert(iterate_apply inc [] = [] )
let () = assert(iterate_apply inc [10] = [11] )
let () = assert(iterate_apply inc [10; 20; 30] = [11; 21; 31] )