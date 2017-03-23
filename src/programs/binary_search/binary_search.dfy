
predicate sorted(arr: array<int>)
    requires arr != null;
    reads arr;
{
   forall i,j :: 0 <= i < j < arr.Length ==> arr[i] <= arr[j]
}


method binary_search(a: array<int>, key: int) returns (index: int)
    requires a != null && sorted(a);
    
    ensures (a == old(a));
    ensures (a[..] == old(a)[..]);

    ensures -1 <= index < a.Length;
    ensures (index == -1) <==> forall k :: 0 <= k < a.Length ==> a[k] != key;
    ensures (0 <= index < a.Length) ==> (a[index] == key);

{
    var low := 0;
    var high :=	a.Length;
    while (low < high)
        invariant 0	<= low <= high <= a.Length;
        invariant forall i ::
           0 <= i <	a.Length && !(low <= i < high) ==> (a[i] != key);
    {
        var mid := (low + high)/2;
        if (a[mid] < key) {
            low := mid + 1;
		} else if (key < a[mid]) {
			high := mid;
        } else {
            return mid;
        }
    }

    return -1;
}


method verify_binary_search()
{
    var a := new int[8];
    var i;

    a[0] := 10; a[1] := 22; a[2] := 35; a[3] := 42;
    a[4] := 48;  a[5] := 109; a[6] := 200; a[7] := 342;

    assert(a[0] == 10);
    assert(a[1] == 22);
    assert(a[2] == 35);
    assert(a[3] == 42);
    assert(a[4] == 48);
    assert(a[5] == 109);
    assert(a[6] == 200);
    assert(a[7] == 342);

    i := binary_search(a, 42);
    assert(a[i] == 42);
    assert(i == 3);

    i := binary_search(a, 842);
    assert(i == -1);
}