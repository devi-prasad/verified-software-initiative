
function sq(x: nat) : nat
{
    x*x
}

method main()
{
    assert(sq(0) == 0);
    assert(sq(1) == sq(sq(1)));
    assert(sq(3) + sq(4) == sq(5));
}