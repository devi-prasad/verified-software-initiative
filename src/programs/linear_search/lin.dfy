function count(vals: seq<int>, key: int): nat
{
   if |vals| == 0 then 0 else (if vals[0] == key then 1 else 0) + count(vals[1..], key)
}

method linear_search(arr: array<int>, key: int) returns (found: bool)
    requires arr != null;
    ensures (found == false) <==> key !in arr[0..];
    ensures (found == true) <==> key in arr[0..];
{
    var index := 0;
    var high :=	arr.Length;
    found := false;
    while (index < high)
        invariant 0 <= index <= high == arr.Length;
        invariant (found == false) && (key !in arr[0..index]);
    {
        if (arr[index] == key) {
            assert(index >= 0);
            assert(found == false);
            assert(key in arr[0..index+1]);
            found := true;
            return;
        }
        index := index + 1;
    }

    assert(found == false);
    assert(index == arr.Length);
    found := false;
}

method test_linear_search()
{
    var a := new int[8];
    var f;

    a[0] := 100; a[1] := -2; a[2] := 200; a[3] := 42;
    a[4] := 42;  a[5] := -2; a[6] := 200; a[7] := 42;

    f := linear_search(a, 1);
    assert(f == false);

    assert(a[0] == 100);
    f := linear_search(a, 100);
    assert(f == true);

    f := linear_search(a, 42);
    assert(f == true);

    f := linear_search(a, 100);
    assert(f);
}
