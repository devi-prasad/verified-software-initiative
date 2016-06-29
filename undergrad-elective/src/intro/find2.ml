
let find key vals =
  let rec find' vals index =  
    match vals with
      | [] -> (false, -1)
      | x :: vals' -> if (x = key)
                      then (true, index) 
                      else find' vals' (index + 1) 
  in find' vals 0;; 


(* these are a few test cases *)
let () = assert(find 10 [] = (false, -1) )
let () = assert(find 10 [20] = (false, -1) )
let () = assert(find 100 [10; 20; 30; 40] = (false, -1) )

let () = assert(find 10 [10] = (true, 0) )
let () = assert(find 10 [20; 10] = (true, 1) )

let () = assert(find 50 [10; 20; 30; 40; 50; 50] = (true, 4) )
