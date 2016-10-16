method linear_search(arr: seq<int>, key: int) returns (found: bool)
    ensures (found == false) <==> key !in arr;
    ensures (found == true) <==> key in arr;
    ensures (arr == old(arr));
{
    var index := 0;
    found := false;
    while (index < |arr|)
        invariant 0 <= index <= |arr|;
        invariant (found == false); 
        invariant (key !in arr[0..index]);
    {
        if (arr[index] == key) {
            assert(key in arr[0..index+1]);
            found := true;
            return;
        }
        index := index + 1;
    }
    assert(found == false);
    assert(index == |arr|);
}

method test_linear_search()
{
    var a := [100, -2, 300, 42, 42, -2, 200, 42];
    var f;

    f := linear_search(a, 100);
    assert(f == true);

    f := linear_search(a, -2);
    assert(f == true);

    f := linear_search(a, 2);
    assert(f == false);

    f := linear_search(a, 42);
    assert(f == true);

    f := linear_search(a, 200);
    assert(f == true);

    f := linear_search(a, -300);
    assert(f == false);

    f := linear_search(a, 300);
    assert(f == true);
}
