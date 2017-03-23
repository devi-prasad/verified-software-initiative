
newtype Element = real

datatype Status = OK | EMPTY


method stack_new() returns (s: seq<Element>)
    ensures s == []
{
	s := [];
}


method stack_empty(s: seq<Element>) returns (b: bool)
    ensures |s| == 0 ==> b == true;
    ensures |s| > 0 ==> b == false;
{
    b := |s| == 0;
}


method stack_full(s: seq<Element>) returns (b: bool)
    ensures b == false;
{
    b := false;
}


method stack_push(stk: seq<Element>, d: Element) returns (stk': seq<Element>)
    ensures (stk' == stk + [d]);
{
	stk' := stk + [d];
}


method stack_peek(stk: seq<Element>) returns (d: Element, r: Status)
    ensures |stk| > 0 ==> (d == stk[|stk| - 1] && r == OK);
    ensures |stk| == 0 ==> (r == EMPTY);
{
    if (|stk| > 0) {
	    d := stk[|stk| - 1];
        r := OK;
    } else {
        r := EMPTY;
    }
}


method stack_pop(stk: seq<Element>) returns (stk': seq<Element>, r: Status)
    ensures |stk| > 0 ==> stk' == stk[.. (|stk|-1)];
    ensures |stk| > 0 ==> |stk'| == |stk|-1 >= 0;
    ensures |stk| > 0 ==> (r == OK);
    ensures |stk| == 0 ==> (stk' == stk && r == EMPTY);
{
    if (|stk| > 0) {
        stk' := stk[0 .. (|stk|-1)];
        r := OK;
    } else {
        stk' := stk;
        r := EMPTY;
    }
}


method verify_unbounded_checked_empty_stack()
{
    var stk : seq<Element>;
    var stk' : seq<Element>;
    var d : Element;
    var b: bool;

    stk := stack_new();
    assert(|stk| == 0);
    
    b := stack_empty(stk);
    assert(b == true);
    b := stack_full(stk);
    assert(b == false);
}

method verify_unbounded_checked_pop_empty_stack()
{
    var stk := stack_new();
    var b := stack_empty(stk);
    var d : Element;
    var r : Status;

    assert(b == true);

    d, r := stack_peek(stk);
    assert(r == EMPTY);
}

method verify_unbounded_checked_general_stack_use()
{
    var stk : seq<Element>;
    var stk' : seq<Element>;
    var d : Element;
    var r : Status;

    stk := stack_new();
    stk' := stack_push(stk, 10.0);
    d, r := stack_peek(stk');
    assert(r == OK && d == 10.0);

    stk' := stack_push(stk', 20.0);
    stk' := stack_push(stk', 30.0);
    assert(|stk'| == 3);
    
    d, r := stack_peek(stk');
    assert(r == OK && d == 30.0);
    
    stk', r := stack_pop(stk');
    assert(r == OK);

    d, r := stack_peek(stk');
    assert(|stk'| == 2);
    assert(r == OK && d == 20.0);

    stk', r := stack_pop(stk');
    assert(r == OK);
    d, r := stack_peek(stk');
    assert(|stk'| == 1);
    assert(r == OK && d == 10.0);

    stk', r := stack_pop(stk');
    assert(r == OK && |stk'| == 0);

    d, r := stack_peek(stk');
    assert(r == EMPTY);
    stk', r := stack_pop(stk');
    assert(r == EMPTY);
}
