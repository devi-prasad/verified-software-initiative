
/**
 * Take a look at the technique. This method doesn't explicitly return a value.
 * It initialized the given array and states this fact in its postcondition.
 *
 */
method array_init(a: array<int>)
    requires a != null;
    requires a.Length > 0;
    modifies a;
    ensures forall j :: 0 <= j < a.Length ==> (a[j] == 0);
{
    var i := 0;
    var high := a.Length;
    while (i < high)
        modifies a;
        invariant 0 <= i <= a.Length;
        invariant forall k :: 0 <= k < i <= high ==> a[k] == 0;
    {
        a[i] := 0;
        i := i + 1;
    }
}

/**
 * we need to state in the postconditions that the array is modified only at
 *  one position - 'index' - and that the rest of the array is untouched.
 * 
 * This technique comes handy when implementing data structures such as stacks
 *  and queues.
 *
 */
method array_update(a: array<int>, index: nat, val: int)
    requires a != null;
    requires 0 <= index < a.Length;
    modifies a;
    ensures a[index] == val;
    ensures forall k :: 0 <= k < a.Length && k != index ==> a[k] == old(a[k]);
{
    a[index] := val;
}

method test_array_new()
{
	var arr: array<int> := new int[8];
	array_init(arr);

	assert(forall j :: 0 <= j < arr.Length ==> arr[j] == 0);

    var j := arr.Length - 1;
	array_update(arr, j, 100);
	assert(arr[j] == 100);

	array_update(arr, 0, -100);
    assert(arr[0] == -100);
	assert(arr[j] == 100);
}
