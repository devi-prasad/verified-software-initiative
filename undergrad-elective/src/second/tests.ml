
let () = 
    let s = Stack.make() in
    let res = Stack.peek s in
    assert(res = Empty)

let () = assert(Stack.peek (Stack.make()) = Empty)
let () = assert(Stack.pop (Stack.make()) = Empty)

let () =
	let s = Stack.make() in
    let res = Stack.push s 10 in
    assert(res = OK [10])

let () =
	let s = Stack.make() in
    let res = Stack.push s 10 in
    match res with
        | OK s' -> assert((Stack.pop s') = OK [])
        | _ -> assert(false)

let () =
    assert((Stack.push (Stack.make()) 10) = OK [10])
