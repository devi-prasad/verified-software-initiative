
newtype Element = real


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


method stack_peek(stk: seq<Element>) returns (d: Element)
    requires |stk| > 0;
    ensures d == stk[|stk| - 1];
{
	d := stk[|stk| - 1];
}


method stack_pop(stk: seq<Element>) returns (stk': seq<Element>)
    requires |stk| > 0;
    ensures stk' == stk[.. (|stk|-1)];
    ensures |stk'| == |stk|-1 >= 0;
{
    stk' := stk[0 .. (|stk|-1)];
}


method verify_unbounded_empty_stack()
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

method verify_unbounded_pop_empty_stack()
{
    var stk := stack_new();
    var b := stack_empty(stk);
    assert(b == true);

    //var stk' := stack_pop(stk);	
}

method verify_unbounded_general_stack_use()
{
    var stk : seq<Element>;
    var stk' : seq<Element>;
    var d : Element;

    stk := stack_new();
    stk' := stack_push(stk, 10.0);
    d := stack_peek(stk');
    assert(d == 10.0);

    stk' := stack_push(stk', 20.0);
    stk' := stack_push(stk', 30.0);
    assert(|stk'| == 3);
    
    d := stack_peek(stk');
    assert(d == 30.0);
    
    stk' := stack_pop(stk');
    d := stack_peek(stk');
    assert(|stk'| == 2);
    assert(d == 20.0);

    stk' := stack_pop(stk');
    d := stack_peek(stk');
    assert(|stk'| == 1);
    assert(d == 10.0);

    stk' := stack_pop(stk');
    assert(|stk'| == 0);
}
