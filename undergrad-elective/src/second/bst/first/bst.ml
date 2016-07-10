open Core
open Core.Std

type tree = | Nil | Node of tree  * int * tree

type preorder = tree -> unit
let rec preorder tree = 
    match tree with
    | Nil -> ()
    | Node (l, v, r) -> 
      Printf.printf "    val: %s\n"  v;
      preorder l;
      preorder r

type inorder = tree -> unit
let rec inorder tree = 
  match tree with
  | Nil -> ()
  | Node (l, v, r) -> 
    inorder l;
    Printf.printf "    val: %d\n"  v;
    inorder r

type postorder = tree -> unit
let rec postorder tree = 
  match tree with
  | Nil -> ()
  | Node (l, v, r) -> 
    postorder l;
    postorder r;
    Printf.printf "    val: %d\n"  v

let null = Nil
let leaf v = Node (Nil, v, Nil)

let r1 = leaf 40
let r2 = Node (leaf 20, 30, (Node (leaf 35, 38, Nil)))
let r3 = Node (r2, 40, (Node (leaf 50, 60, Nil)))
