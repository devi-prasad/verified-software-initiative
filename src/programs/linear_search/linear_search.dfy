
method linear_search(arr: array<int>, key: int) returns (index: int)
    requires arr != null && arr.Length > 0;

    ensures (arr == old(arr));
    ensures (arr[..] == (old(arr))[..]);

    ensures (index == -1) <==> 
      forall k :: 0 <= k < arr.Length ==> arr[k] != key;
    
    ensures 0 <= index < arr.Length ==> arr[index] == key;
    ensures forall k :: 0 <= k < index < arr.Length ==> arr[k] != key;

    ensures forall k :: 0 <= k < arr.Length ==> 
      ( (arr[k] == key && (forall j :: 0 <= j < k ==> arr[j] != key)) <==> 
         (index == k));

{
    index := 0;
    ghost var prevElements := arr[..];
    while (index < arr.Length)
        decreases arr.Length - index;
        invariant 0 <= index <= arr.Length;
        invariant forall j :: 0 <= j < index ==> arr[j] != key;
        invariant arr[..] == prevElements;
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
    assert(a[2] == 200);

    i := linear_search(a, 1);
    assert(i == -1);

    i := linear_search(a, 100);
    assert(a[i] == 100);
    assert(i == 0);

    i := linear_search(a, 200);
    assert(a[i] == 200);
    assert(i == 2);

    i := linear_search(a, 999);
    assert(i == -1);
}
