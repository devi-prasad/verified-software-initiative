
method linear_search(arr: array<int>, key: int) returns (index: int)
    requires arr != null;
    ensures index >= 0 ==> index < arr.Length && arr[index] == key;
    ensures forall j :: 0 <= j < index < arr.Length ==> arr[j] != key;
    ensures index < 0 ==> forall k :: 0 <= k < arr.Length ==> arr[k] != key;
{
    index := 0;
    var high :=	arr.Length;
    while (index < high)
        invariant 0 <= index <= high == arr.Length;
        invariant forall j :: 0 <= j < index ==> arr[j] != key;
    {
        if (arr[index] == key) {
            return;
        }
        index := index + 1;
    }

    return -1;
}

method test_linear_search()
{
    var a := new int[8];
    var i;

    a[0] := 100; a[1] := -2; a[2] := 200; a[3] := 42;
    a[4] := 42;  a[5] := -2; a[6] := 200; a[7] := 42;

    i := linear_search(a, -2);
    assert(i == 1);

    i := linear_search(a, 42);
    assert(i == 3);

    i := linear_search(a, 100);
    assert(i == 0);

    i := linear_search(a, 1);
    assert(i < 0);

}
