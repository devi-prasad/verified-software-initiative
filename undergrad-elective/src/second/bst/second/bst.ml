open Core
open Core.Std

type tree = | Nil | Node of tree  * int * tree

type preorder = tree -> (int list -> int -> int list) -> int list -> int list
let rec preorder tree f seed = 
    match tree with
    | Nil -> seed
    | Node (l, v, r) -> 
      let folded_cur = f seed v in
        let folded_left = preorder l f folded_cur in
          preorder r f folded_left

type inorder = tree -> (int list -> int -> int list) -> int list -> int list
let rec inorder tree f seed= 
    match tree with
    | Nil -> seed
    | Node (l, v, r) -> 
        let folded_left = inorder l f seed in
          let folded_cur = f folded_left v in
            inorder r f folded_cur

type postorder = tree -> (int list -> int -> int list) -> int list -> int list
let rec postorder tree f seed = 
    match tree with
    | Nil -> seed
    | Node (l, v, r) -> 
        let folded_left = postorder l f seed in
          let folded_right = postorder r f folded_left in
            f folded_right v

let null = Nil
let leaf v = Node (Nil, v, Nil)

let r1 = leaf 40
let r2 = Node (leaf 20, 30, (Node (leaf 35, 38, Nil)))
let r3 = Node (r2, 40, (Node (leaf 50, 60, Nil)))

(* 
inorder r3 () (fun l v -> Printf.printf "%d " v);;
inorder r3 [] (fun l v -> l @[v]);
inorder r3 0 (+);;

postorder r3 (+) 0 = inorder r3 (+) 0
*)
