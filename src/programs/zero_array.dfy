

method init_array(arr: array<int>)
requires (arr != null);
modifies arr;
{
    var i := 0;
    var high := arr.Length;

    while (i < high)
        modifies arr;
        invariant 0 <= i <= high <= arr.Length;
    {
        arr[i] := 0;
        i := i + 1;
    }
}
