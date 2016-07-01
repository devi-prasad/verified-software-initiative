
(* defVarDim : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list *)
let defVarDim v d env = 
  let rec duplicate v e =
    match e with
    | [] -> false
    | (x, _) :: e' -> if (x = v) then true else duplicate v e'
  and
  newVar v d env = (v, d) :: env
  in
  if not (duplicate v env) then newVar v d env else env


(* exists : 'a -> ('a * 'b) list -> ('a * 'b) option *)
let rec exists v env = 
  match env with
  | [] -> None
  | (x, d) :: env' -> if (x = v) then Some (x, d) else exists v env' 


type atom = char

type expr = 
    | Add of expr * expr
    | Sub of expr * expr
    | Mul of expr * expr
    | Div of expr * expr
    | Var of atom

let product d1 d2 =
    if d1 = None || d2 = None then None
    else let
      Some (m1, l1, t1) = d1 and
      Some (m2, l2, t2) = d2
      in Some (m1 + m2, l1 + l2, t1 + t2)

let ratio d1 d2 =
    if d1 = None || d2 = None then None
    else let
      Some (m1, l1, t1) = d1 and
      Some (m2, l2, t2) = d2
      in Some (m1 - m2, l1 - l2, t1 - t2)

let rec dim expr env = 
    match expr with
    | Add (e1, e2) | Sub (e1, e2) -> 
      let d1 = dim e1 env and
      d2 = dim e2 env
      in if d1 = d2 then d1 else None

    | Mul (e1, e2) ->
      let d1 = dim e1 env and
      d2 = dim e2 env
      in (product d1 d2)

    | Div (e1, e2) ->
      let d1 = dim e1 env and
      d2 = dim e2 env
      in (ratio d1 d2)

    | Var x -> 
      match exists x env with
      | None -> None
      | Some (_, d) -> d


let () = 
    let env = defVarDim 'v' (0, 1, -1) (defVarDim 'u' (0, 1, -1) (defVarDim 't' (0, 0, 1) []))
    in assert((List.length env) = 3);;


let () = 
    let env = defVarDim 'v' 1 (defVarDim 'u' 2 (defVarDim 't' 3 []))
    in assert((List.length env) = 3);;

let () = 
    let env = defVarDim 'v' 1 (defVarDim 'u' 2 (defVarDim 't' 3 []))
    in assert(exists 'v' env = Some ('v', 1) &&
              exists 't' env = Some ('t', 3) &&
              exists 'x' env = None);;

let () = 
    let env = defVarDim 'v' (Some (0, 1, -1)) (defVarDim 'u' (Some (0, 1, -1)) (defVarDim 't' (Some (0, 0, 1)) [])) and
      exp = Add ((Var 'v'), (Var 'u')) in
      assert (dim exp env = Some (0, 1, -1))

