open Core
open Core.Std
open Fn

type pos = (int * int)
type board = pos list

let width  = 5
let height = 5

let glider: board = [(4, 2); (2, 3); (4, 3); (3, 4); (4, 4)]


type isAlive = board -> pos -> bool
let isAlive b p = List.exists b ((=) p)

type isEmpty = board -> pos -> bool
let isEmpty  b p = not (isAlive b p)


type drawBoard = board -> unit
let drawBoard b = 
	let drawCell (p: pos) = Printf.printf "(%d, %d)" (fst p) (snd p) in
    let _ = List.map b drawCell in
    Printf.printf "\n\n"


type wrap = pos -> pos
let wrap (x, y) = ( ((x-1) mod width)  + 1,
                    ((y-1) mod height) + 1 )


type neighbs = pos -> pos list
let neighbs (p:pos) : pos list =
    let (x, y) = p in
    List.map ~f:wrap [ (x-1, y-1); (x, y-1); 
                       (x+1, y-1); (x-1, y); 
                       (x+1, y); (x-1, y+1); 
                       (x, y+1); (x+1, y+1); 
                     ]


(** This is an infix definition of the function composition operator 
  * explain how is this different from the @@ operator.
  * think about the |> (pipe) operator also 
*)
let ($) = Fn.compose


type liveneighbs = board -> pos -> int
let liveneigbhs b = List.length $ List.filter ~f:(isAlive b) $ neighbs
(**
    let liveneigbhs b p = List.length @@ List.filter ~f:(isAlive b) @@ neighbs p
**)


type survivors = board -> pos list
let survivors b =
    let reqLiveNeighbs x = (x = 2)||(x = 3) in
    List.filter b (reqLiveNeighbs $ (liveneigbhs b))



let rec rmdups : 'a list -> 'a list =  
	fun l ->
      match l with
      | [] -> []
      | x :: xs -> x :: rmdups (List.filter xs ((<>) x))



type births = board -> pos list
let births (b:board) : pos list = 
    let cells = rmdups (List.concat (List.map b neighbs) ) and
        mayProduce p = (isEmpty b p) && (liveneigbhs b p = 3) in
      List.filter cells mayProduce



type nextgen = board -> board
let nextgen b = List.append (survivors b) (births b)



type life = board -> unit
let life b = 
    let rec life' b b' turns = 
       if turns < 50 && (b <> b') then
         let _ = drawBoard b' in 
         life' b' (nextgen b') (turns+1)
    in life' [] b 1

