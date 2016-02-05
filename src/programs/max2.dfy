
method max2(a: int, b: int) returns (max: int)
    ensures a >= b ==> max == a;
    ensures a < b ==> max == b;
{
    max := a;
    if (b > a) {
        max := b;
    }
}

method test_max()
{
    var m: int;

    m := max2(10, 20);
    assert(m == 20);

    m := max2(20, 10);
    assert(m == 20);

    m := max2(-20, 10);
    assert(m == 10);

    m := max2(10, 10);
    assert(m == 10);
}