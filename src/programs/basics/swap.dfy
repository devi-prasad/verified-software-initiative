
method swap(a: int, b: int) returns (x: int, y: int)
ensures (x == b && y == a);
{
    x, y := b, a;
}

method main()
{
    var a: int, b: int;
    
    a := 100;
    b := 200;
    a, b := swap(a, b);
    
    assert(a == 200);
    assert(b == 100);
}
