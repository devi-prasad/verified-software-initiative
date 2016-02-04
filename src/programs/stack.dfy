
datatype Stack = Stack(stk: array<int>, top: int)

datatype State = OK | FULL | EMPTY

datatype Result = Result(data: int, status: State)
function val(res: Result) : int
{
    res.data
}

function status(res: Result) : State
{
    res.status
}

method stack_new(size: nat) returns (stack: Stack)
    requires size > 0;
    ensures stack.stk != null;
    ensures stack.stk.Length == size;
    ensures stack.top == -1;
    ensures fresh(stack)
{
    var s := new int[size];
    stack := Stack(s, -1);
}

function stack_size(s: Stack) : int
    requires s.stk != null;
{
    s.top + 1
}

function stack_depth(s: Stack) : int
    requires s.stk != null;
{
    s.stk.Length
}

method stack_push(s: Stack, d: int) returns (rstack: Stack, res: Result)
    requires s.stk != null;
    requires s.stk.Length > 0;
    requires s.top >= -1;
    ensures (s.stk.Length > (s.top + 1)) ==> (rstack.top == s.top + 1) &&
                                              (rstack.stk == s.stk) && 
                                              rstack.stk.Length > rstack.top == (s.top+1) >= 0 &&
                                              (rstack.stk[rstack.top] == d) && 
                                              (res == Result(d, OK));
    
    ensures (s.stk.Length == (s.top + 1)) ==> /*(s == old(s)) && (rstack == old(s)) && 
                                              s.top == old(s.top) && s.stk == old(s.stk) &&
                                              rstack.stk[rstack.top] == s.stk[s.top] &&*/
                                              rstack == old(s) && s == old(s) && 
                                              res == Result(0, FULL);
    modifies s.stk;
{
    if (s.stk.Length > (s.top + 1)) {
        s.stk[s.top + 1] := d;
        rstack := Stack(s.stk, s.top + 1);
        res := Result(d, OK);
    } else {
        rstack := s;
        res := Result(0, FULL);
    }
}

method stack_pop(s: Stack) returns (rstack: Stack, res: Result)
    requires s.stk != null;
    requires s.top >= -1;
    requires s.stk.Length > 0;
    requires s.stk.Length > s.top;
    ensures (s.stk.Length > s.top > -1) ==> 
                             (rstack == Stack(s.stk, s.top - 1)) &&
                             (res == Result(s.stk[s.top], OK));

    ensures (s.top == -1) ==> (rstack == s) &&
                              (res == Result(0, EMPTY));
{
    if (s.top > -1) {
        res := Result(s.stk[s.top], OK);
        rstack := Stack(s.stk, s.top - 1);
    } else {
         rstack := s;
         res := Result(0, EMPTY);
    }
}

method test_one_element_stack()
{
    var stk := stack_new(1);
    var rstk, res;

    assert(stk.stk != null);
    assert(stack_size(stk) == 0);

    rstk, res := stack_push(stk, 10);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 10);
    assert(stack_size(rstk) == stack_size(stk) + 1);
    assert(rstk.stk[rstk.top] == 10);

    rstk, res := stack_push(rstk, 20);
    assert(stack_size(rstk) == 1);
    assert(val(res) == 0 && status(res) == FULL);
    assert(rstk.stk != null && rstk.stk == stk.stk);
    assert(rstk.stk[rstk.top] == 10);

    rstk, res := stack_pop(rstk);
    assert(stack_size(rstk) == 0);
    assert(status(res) == OK);
//    assert(val(res) == 10);

}

method test_one_element_stack_push_pop()
{
    var stk := stack_new(1);
    var rstk, res;

    assert(stk.stk != null);
    assert(stack_size(stk) == 0);

    rstk, res := stack_push(stk, 10);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 10);
    assert(stack_size(rstk) == stack_size(stk) + 1);
    assert(rstk.stk[rstk.top] == 10);

    rstk, res := stack_pop(rstk);
    assert(stack_size(rstk) == 0);
    assert(status(res) == OK);
    assert(val(res) == 10);

    rstk, res := stack_pop(rstk);
    assert(stack_size(rstk) == 0);
    assert(status(res) == EMPTY);
    assert(val(res) == 0);

    rstk, res := stack_push(stk, 20);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 20);
    assert(stack_size(rstk) == stack_size(stk) + 1);
    assert(rstk.stk[rstk.top] == 20);

    rstk, res := stack_pop(rstk);
    assert(stack_size(rstk) == 0);
    assert(status(res) == OK);
    assert(val(res) == 20);
}

method test_two_element_stack()
{
    var stk := stack_new(2);
    var rstk, res;

    assert(stk.stk != null);
    assert(stack_size(stk) == 0);

    rstk, res := stack_push(stk, 10);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 10);
    assert(stack_size(rstk) == stack_size(stk) + 1);

    rstk, res := stack_push(rstk, 20);
    assert(stack_size(rstk) == 2);
    assert(status(res) == OK);
    assert(val(res) == 20);
    assert(stack_size(rstk) == stack_size(stk) + 2);

    rstk, res := stack_push(rstk, 30);
    assert(val(res) == 0 && status(res) == FULL);
    assert(stack_size(rstk) == 2);
}

