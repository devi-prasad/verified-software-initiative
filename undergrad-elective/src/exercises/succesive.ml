(*
Ocaml function named 'successive' that takes two arguments: 
'lst'​ - a list, and 'key' - a value. The function detects if 'lst' contains 
two consecutive 'key' values in the list. Use Ocaml's pattern matching 
constructs to simplify program logic as well as to let the compiler detect 
missing patterns.
*)

let rec successive lst key =
    match lst with
      | [] -> false
      | [_x] -> false
      | x :: y :: lst' -> if x = key && y == key
                          then true
                          else successive (y::lst') key


(* these are a few test cases *)
let () = assert(successive [] 10 = false)
let () = assert(successive [10] 10 = false)
let () = assert(successive [10; 20; 10] 10 = false)
let () = assert(successive [10; 10; 20] 10 = true)
let () = assert(successive [100; 10; 200; 10; 10; 20] 10 = true)
