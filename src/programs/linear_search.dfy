
method linear_search(a: array<int>, key: int) returns (index: int)
    requires a != null;
    ensures index >= 0 ==> index < a.Length && a[index] == key;
    ensures index < 0 ==> forall k :: 0 <= k < a.Length ==> a[k] != key;
{
    var i := 0;
    var high :=	a.Length;
    while (i < high)
        invariant 0 <= i <= high <= a.Length;
        invariant forall j :: 0 <= j < i ==> a[j] != key;
    {
        if (a[i] == key) {
            return i;        
        }
        i := i + 1;
    }

    return -1;
}
