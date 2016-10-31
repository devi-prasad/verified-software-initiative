
method find_even(arr: array<int>) returns (found: bool)
    requires arr != null;
    requires arr.Length > 0;
    
    ensures (arr[..] == old(arr)[..]);

    ensures (found == false) <==> (forall i :: 0 <= i < arr.Length ==>
                                                              (arr[i]%2 != 0) )
{
    var index := 0;
    found := false;
    ghost var i := -1;
    while (index < arr.Length)
        invariant 0 <= index <= arr.Length;
        decreases arr.Length - index;
        invariant (found == false);
        invariant forall i :: 0 <= i < index  ==> arr[i]%2 != 0; 
    {
        if (arr[index]%2 == 0) {
          found := true;
          i := index;
          return;
        }
        index := index + 1;
    }
    assert(found == false);
}

method verify_find_even()
{
    var a := new int[4];
    var found;

    a[0] := 101; a[1] := 21; a[2] := 205; a[3] := 49;

    found := find_even(a);
    assert(!found);

    a[2] := a[2] + 1;
    found := find_even(a);
    assert(found);

    a[2] := a[2] + 1;
    found := find_even(a);
    assert(!found);

    a[0] := a[3] + 1;
    found := find_even(a);
    assert(found);
    assert(a[0] == 50);
}
