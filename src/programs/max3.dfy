
method max3(a: int, b: int, c: int) returns (max: int, vn: char)
    ensures (a >= b >= c) || (a >= c >= b) ==> max == a && vn == 'a';
    ensures (b > a >= c)  || (b >= c > a)  ==> max == b && vn == 'b';
    ensures (c > a >= b)  || (c > b > a)   ==> max == c && vn == 'c';
{
    max := a; vn := 'a';
    if (b > max) {
        max := b;  vn := 'b';
    }
    if (c > max) {
        max := c;  vn := 'c';
    }
}

method test_max()
{
    var m: int;
    var nv: char;


    m, nv := max3(10, 10, 10);
    assert(m == 10 && nv == 'a');

    m, nv := max3(30, 20, 20);
    assert(m == 30 && nv == 'a');

    m, nv := max3(30, 10, 20);
    assert(m == 30 && nv == 'a');

    m, nv := max3(30, 20, 10);
    assert(m == 30 && nv == 'a');

    m, nv := max3(20, 30, 10);
    assert(m == 30 && nv == 'b');

    m, nv := max3(10, 30, 20);
    assert(m == 30 && nv == 'b');

    m, nv := max3(10, 30, 10);
    assert(m == 30 && nv == 'b');

    m, nv := max3(10, 10, 30);
    assert(m == 30 && nv == 'c');

    m, nv := max3(10, 20, 30);
    assert(m == 30 && nv == 'c');

    m, nv := max3(20, 10, 30);
    assert(m == 30 && nv == 'c'); 
}
