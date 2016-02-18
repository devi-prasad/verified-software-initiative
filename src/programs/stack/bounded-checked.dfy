newtype Element = real

datatype Stack = Stack(size: nat, stk: seq<Element>)
datatype Result = OK(res: Element) | EMPTY | FULL

method stack_new(size: nat) returns (s: Stack)
    requires 0 < size < 512;
    ensures s == Stack(size, []);
{
	s := Stack(size, []);
}

method stack_empty(s: Stack) returns (b: bool)
    ensures |s.stk| == 0 ==> b == true;
    ensures |s.stk| > 0 ==> b == false;
{
    b := (|s.stk| == 0);
}

method stack_full(s: Stack) returns (b: bool)
    ensures b == (|s.stk| == s.size);
{
    b := |s.stk| == s.size;
}

method stack_push(s: Stack, d: Element) returns (s': Stack, r: Result)
    ensures 0 <= |s.stk| < s.size ==> s' == Stack(s.size, s.stk + [d]) &&
                                      r == OK(d);
    ensures 0 <= |s.stk| == s.size ==> s' == s && r == FULL
{
    if (|s.stk| < s.size) {
	    s' := Stack(s.size, s.stk + [d]);
        r  := OK(d);
    } else {
        s' := s;
        r  := FULL;
    }
}

method stack_peek(s: Stack) returns (r: Result)
    ensures |s.stk| > 0 ==> r == OK(s.stk[|s.stk| - 1]);
    ensures |s.stk| == 0 ==> r == EMPTY;
{
    if (|s.stk| > 0) {
	    var d := s.stk[ |s.stk| - 1 ];
        r := OK(d);
    } else {
        r := EMPTY;
    }
}

method stack_pop(s: Stack) returns (s': Stack, r: Result)
    ensures |s.stk| > 0 ==> s' == Stack(s.size, s.stk[.. |s.stk|-1 ]);
    ensures |s.stk| > 0 ==> (r == OK(s.stk[ |s.stk|-1 ]));
    ensures |s.stk| == 0 ==> (s' == s && r == EMPTY);
{
    if (|s.stk| > 0) {
        s' := Stack(s.size, s.stk[0 .. (|s.stk|-1)]);
        var top := |s.stk|-1;
        r := OK(s.stk[top]);
    } else {
        s' := s;
        r := EMPTY;
    }
}


method test_create_empty_stack()
{
    var stk  : Stack;
    var stk' : Stack;
    var d    : Element;
    var b    : bool;
    var r    : Result;
   
    stk := stack_new(1);
    b := stack_empty(stk);
    assert(b == true);
    b := stack_full(stk);
    assert(b == false);
}

method test_peek_empty_stack()
{
    var d : Element;
    var s := stack_new(1);
    var s': Stack;
    var b := stack_empty(s);
    var r := stack_peek(s);

    assert(b == true);
    assert(r == EMPTY);

    s', r := stack_pop(s);
    assert(r == EMPTY && s == s');
}

method test_pop_stack()
{
    var d  : Element;
    var s  := stack_new(1);
    var s';
    var b  := stack_empty(s);
    var r  := stack_peek(s);

    assert(b == true);
    assert(r == EMPTY);

    s', r := stack_push(s, Element(10));
    b  := stack_empty(s');
    assert(b == false);
    b := stack_full(s');
    assert(b == true);

    s', r := stack_push(s', Element(100));
    assert(r == FULL);

    r := stack_peek(s');
    assert(r == OK(Element(10)));
    s', r := stack_pop(s');
    assert(r == OK(Element(10)));
    b  := stack_empty(s);
    assert(b == true);
    s', r := stack_pop(s');
    assert(r == EMPTY);
}

method test_general_stack()
{
    var s  := stack_new(3);
    var s' : Stack;
    var d  : Element;
    var b  : bool;
    var r  : Result;

    s', r := stack_push(s, Element(10));
    assert(r == OK(Element(10)));
    r := stack_peek(s');
    assert(r == OK(Element(10)));

    s', r := stack_push(s', Element(20));
    s', r := stack_push(s', Element(30));
    b := stack_full(s'); assert(b == true);
  
    s', r := stack_push(s', Element(30));
    assert(r == FULL);

    r := stack_peek(s');
    assert(r == OK(Element(30)));
    
    s', r := stack_pop(s');
    assert(r == OK(Element(30)));

    r := stack_peek(s');
    assert(r == OK(Element(20)));

    s', r := stack_pop(s');
    r := stack_peek(s');
    assert(r == OK(Element(10.0)));
    s', r := stack_pop(s');
    assert(r == OK(Element(10.0)));

    r := stack_peek(s');
    assert(r == EMPTY);
    s', r := stack_pop(s');
    assert(r == EMPTY);
}

