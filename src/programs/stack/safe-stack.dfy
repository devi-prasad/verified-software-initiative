
datatype State = OK | FULL | EMPTY

datatype Result = Result(data: int, status: State)

datatype Stack = Stack(stk: array<int>, top: int)


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


function stack_peek(s: Stack) : Result
    requires s.stk != null;
    requires s.stk.Length > s.top >= -1;
    reads s.stk;
{
    if (s.top > -1) then
        Result(s.stk[s.top], OK)
     else
        Result(0, EMPTY)
}


function stack_full(s: Stack) : bool
    requires s.stk != null;
    requires s.stk.Length > s.top >= -1;
    reads s.stk;
{
    (s.top + 1 == s.stk.Length)
}


function stack_empty(s: Stack) : bool
    requires s.stk != null;
    requires s.stk.Length > s.top >= -1;
    reads s.stk;
{
    (s.top == -1)
}


method stack_push_safe(s: Stack, d: int) returns (rstack: Stack, res: Result)
    requires s.stk != null;
    requires s.stk.Length > 0;
    requires s.stk.Length > (s.top + 1) >= 0;
    
    modifies s.stk;
    ensures rstack == Stack(s.stk, s.top+1);
    ensures forall k :: 0 <= k < rstack.top ==> (rstack.stk[k] == old(s.stk[k]));
    ensures rstack.stk[rstack.top] == d;
    ensures res == Result(d, OK);
{
    s.stk[s.top + 1] := d;
    rstack := Stack(s.stk, s.top+1);
    res := Result(d, OK);
}


function method stack_pop_safe(s: Stack) : Stack
    requires s.stk != null;
    requires s.top >= -1;
    requires s.stk.Length > 0;
    requires s.stk.Length > s.top;
{
    if (s.top > -1) then Stack(s.stk, s.top - 1) else s
}


method verify_safe_one_element_stack()
{
    var stk := stack_new(1);
    var rstk, res;

    assert(stk.stk != null);
    assert(stack_size(stk) == 0);

    rstk, res := stack_push_safe(stk, 10);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 10);
    assert(stack_size(rstk) == stack_size(stk) + 1);
    assert(rstk.stk[rstk.top] == 10);
    assert(stack_peek(rstk).status == OK);
    assert(stack_peek(rstk).data == 10);

    assert(stack_full(rstk));

    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);

    assert(stack_empty(rstk));
    rstk, res := stack_push_safe(rstk, 20);
    assert(stack_peek(rstk).data == 20);
    
    rstk := stack_pop_safe(rstk);
    assert(stack_empty(rstk));
}

method verify_safe_one_element_stack_push_pop()
{
    var stk := stack_new(1);
    var rstk, res;

    assert(stk.stk != null);
    assert(stack_size(stk) == 0);

    rstk, res := stack_push_safe(stk, 10);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 10);
    assert(stack_size(rstk) == stack_size(stk) + 1);
    assert(rstk.stk[rstk.top] == 10);

    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);
    assert(stack_empty(rstk));

    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);
    assert(stack_empty(rstk));

    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);
    assert(stack_empty(rstk));

    rstk, res := stack_push_safe(stk, 20);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 20);
    assert(stack_size(rstk) == stack_size(stk) + 1);
    assert(rstk.stk[rstk.top] == 20);

    rstk, res := stack_push_safe(stk, 20);
    rstk, res := stack_push_safe(stk, 20);
    rstk, res := stack_push_safe(stk, 20);

    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);
    assert(stack_empty(rstk));
}


method verify_safe_two_element_stack()
{
    var stk := stack_new(2);
    var rstk, res;

    assert(stk.stk != null);
    assert(stack_size(stk) == 0);

    rstk, res := stack_push_safe(stk, 10);
    rstk, res := stack_push_safe(rstk, 20);
    assert(stack_peek(rstk).data == 20);
    assert(stack_size(rstk) == 2);
    assert(stack_depth(rstk) == 2);
    assert(stack_full(rstk));

    rstk:= stack_pop_safe(rstk);
    assert(!stack_empty(rstk));
    assert(stack_size(rstk) == 1);
    assert(stack_peek(rstk).data == 10);
    rstk := stack_pop_safe(rstk);
    assert(stack_empty(rstk));
    rstk := stack_pop_safe(rstk);
    assert(stack_empty(rstk));
}

method verify_safe_general_stack_use()
{
    var stk := stack_new(4);
    var rstk, res;

    assert(stk.stk != null);
    assert(stack_size(stk) == 0);

    rstk, res := stack_push_safe(stk, 10);
    assert(stack_size(rstk) == 1);
    assert(status(res) == OK);
    assert(val(res) == 10);
    assert(stack_size(rstk) == stack_size(stk) + 1);

    assert(stack_peek(rstk).data == 10);
    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);

    rstk, res := stack_push_safe(rstk, 30);
    rstk, res := stack_push_safe(rstk, 20);

    assert(stack_peek(rstk).data == 20);
    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 1);
    assert(stack_peek(rstk).data == 30);
    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);

    rstk := stack_pop_safe(rstk);
    assert(stack_size(rstk) == 0);

    rstk, res := stack_push_safe(rstk, 25); assert(res.status == OK);
    rstk, res := stack_push_safe(rstk, 50); assert(res.status == OK);
    rstk, res := stack_push_safe(rstk, 75); assert(res.status == OK);
    rstk, res := stack_push_safe(rstk, 100); assert(res.status == OK);
    assert(stack_full(rstk));
    //rstk, res := stack_push_safe(rstk, 100); // precondition doesn't hold!

    assert(stack_peek(rstk).data == 100);
    rstk := stack_pop_safe(rstk);
    rstk := stack_pop_safe(rstk);
    assert(stack_peek(rstk).data == 50);
    rstk := stack_pop_safe(rstk);
    assert(stack_peek(rstk).data == 25);
    rstk := stack_pop_safe(rstk);
    assert(stack_empty(rstk));
}
