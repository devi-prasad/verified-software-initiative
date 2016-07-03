(*  A very simple stack-based expression evaluator.
    This example demonstrates the expressiveness of sum types and 
    pattern matching. This also serves as an introductory example
    before we refactor this code and move on to more sophisticated examples.
 *)

(* The instruction set. *)
type inst =
    | Push of int
    | Add
    | Sub
    | Swap


(* Evaluator for one instruction. 
   The evaluator works on a stack of operands.
   Push instruction places the new operand on the top of the stack.
   Add and Sub instructions consume the top two elements, performs the 
   operation, and places the result on the top of the stack.
   Swap is required to change the order of topmost two elements.

   Note the way asserts are used to state the preconditions. 
*)

let evaluator stk inst = 
   match inst with
   | Push x -> x :: stk
   | Add -> (match stk with
            | a :: b :: stk' -> (a+b) :: stk'
            | _ -> assert(false) )
   | Sub -> (match stk with
            | a :: b :: stk' -> (a-b) :: stk'
            | _ -> assert(false) )
   | Swap -> (match stk with
   	         | a :: b :: stk' -> b :: a :: stk'
   	         | _ -> stk )


(*  This function specifies the meaning of a program.
	A program is represented as a list of instructions which are sequentially
	executed. The interpreter needs a stack to evaluate each instruction.
	Note carefully how the stack threaded through the recursive calls. 
*)
let meaning program = 
	let rec interp program stk = 
      match program with
      | [] -> stk
      | inst :: program' -> interp program' (evaluator stk inst)
    in interp program []


let () = 
    let a::_ = meaning [Push 10; Push 20; Add; Push 5; Swap; Sub] in
    print_newline(); 
    print_string("    Result: "); print_int(a); 
    print_newline(); print_newline();

