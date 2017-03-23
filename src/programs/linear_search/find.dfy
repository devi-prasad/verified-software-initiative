
method linear_search(arr: array<int>, key: int) returns (index: int)
    requires arr != null;
    requires arr.Length > 0;

    ensures (arr[..] == old(arr)[..]);

    ensures -1 <= index < arr.Length;

    ensures (index == -1) <==>
        forall k :: 0 <= k < arr.Length ==> arr[k] != key;

    ensures (0 <= index < arr.Length) ==>
        (arr[index] == key && (forall i :: 0 <= i < index ==> arr[i] != key));

{
    index := 0;
    while (index < arr.Length)
        decreases arr.Length - index;
        invariant 0 <= index <= arr.Length;
        invariant forall j :: 0 <= j < index ==> arr[j] != key;
    {
        if (arr[index] == key) {
            return;
        }
        index := index + 1;
    }

    return -1;
}


method verify_linear_search()
{
    var a := new int[8];
    var i;

    a[0] := 100; a[1] := 22; a[2] := 200; a[3] := 42;
    a[4] := 42;  a[5] := -2; a[6] := 200; a[7] := 42;

    assert(a[0] == 100);
    assert(a[1] == 22);
    assert(a[2] == 200);
    assert(a[3] == 42);
    assert(a[4] == 42);
    assert(a[5] == -2);
    assert(a[6] == 200);
    assert(a[7] == 42);

    i := linear_search(a, 999);
    assert(i == -1);

    i := linear_search(a, 1);
    assert(i == -1);

    i := linear_search(a, 100);
    assert(a[i] == 100);
    assert(i == 0);

    i := linear_search(a, 200);
    assert(a[i] == 200);
    assert(i == 2);

    i := linear_search(a, 42);
    assert(a[i] == 42);
    assert(i == 3);
}
