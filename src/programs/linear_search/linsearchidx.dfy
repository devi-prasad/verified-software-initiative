method linear_search(arr: seq<int>, key: int) returns (found: bool, index: int)
    ensures (found == false) <==> key !in arr && index == -1;
    ensures (found == true) ==> (0 <= index < |arr| && arr[index] == key);
//    ensures (found == true) ==> (0 <= index < |arr| && arr[index] == key) ==>
//                                   forall j :: 0 <= j < index < |arr| ==> arr[j] != key;
    ensures (arr == old(arr));
{
    index := 0;
    found := false;
    while (index < |arr|)
        invariant 0 <= index <= |arr|;
        invariant (found == false); 
        invariant (key !in arr[0..index]);
        invariant forall j :: 0 <= j < index  ==> arr[j] != key;
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
    index := -1;
}

method test_linear_search()
{
    var a := [100, -2, 300, 42, 42, -2, 200, 42];
    var f;
    var i;

    f, i := linear_search(a, 100);
    assert(f == true);
    assert(i == 0);

    f, i := linear_search(a, 999);
    assert(f == false && i == -1);

    f, i := linear_search(a, -2);
    assert(f == true);
    assert(i == 5 || i == 1);

    f, i := linear_search(a, 2);
    assert(f == false);
    assert(i == -1);

    f, i := linear_search(a, 42);
    assert(f == true);
    assert(i == 3 || i == 4 || i == 7);

    f, i := linear_search(a, 200);
    assert(f == true);
    assert(i == 6);

    f, i := linear_search(a, -300);
    assert(f == false);

    f, i := linear_search(a, 300);
    assert(f == true);
    assert(i == 2);
}
