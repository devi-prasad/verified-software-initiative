open Core.Std

type role = | Director 
            | Coordinator
            | Instructor
            | Researcher
            | Staff
            | Intern

type dept = | ComputerScience
            | Physics
            | Math
            | DataScience
            | Statistics
            | Humanity

type empid = int
type name  = string
type employee = (empid * name * dept * role)
type office = employee list

let rec researchers office = 
  match office with
      | [] -> []
      | e::office' -> let (_, _, _, r) = e in
          if r = Researcher then e :: researchers office'
          else researchers office'

let findresearchers office = 
  List.filter office ~f:(fun (_, _, _, r) -> r = Researcher)

(*
  Tests
*)
let () = assert(researchers [] = [])

let () = 
    let e = (101, "a", Math, Researcher) in
    assert(researchers [e] = [e])

let () = 
    let e1 = (101, "a", Math, Intern) in
    let e2 = (302, "b", Humanity, Staff) in
    assert(researchers [e1; e2] = [])

let () = 
    let e1 = (101, "a", Math, Intern) in
    let e2 = (302, "b", Humanity, Researcher) in
    let e3 = (302, "c", Humanity, Staff) in
    assert(findresearchers [e1; e2; e3] = [e2])

