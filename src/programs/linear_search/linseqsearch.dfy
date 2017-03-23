
method search_seq(ds: seq<int>, key: int) returns (index: int)
    requires |ds| > 0;

    ensures -1 <= index < |ds|;

    ensures (index == -1) <==> key !in ds;

    ensures (0 <= index < |ds|) ==> 
        (ds[index] == key && (forall i :: 0 <= i < index ==> ds[i] != key));
{
    index := 0;
    while (index < |ds|)
        decreases |ds| - index;
        invariant 0 <= index <= |ds|;
        invariant forall j :: 0 <= j < index ==> ds[j] != key;
    {
        if (ds[index] == key) {
            return;
        }
        index := index + 1;
    }

    index := -1;
}


method verify_search_seq(s: seq<int>)
    requires 10 == |s|;
    requires s[0] == 100;
    requires s[1] == s[5] == -2;
    requires s[2] == 300;
    requires (s[3] == s[4] == s[7] == 42);
    requires (s[6] == 200);
    requires (s[8] == 55);
    requires (s[9] == 0);
{
    var i;

    i := search_seq(s, 100);
    assert(i == 0);
 
    i := search_seq(s, 999);
    assert(i == -1);

    i := search_seq(s, 200);
    assert(i == 6);

    i := search_seq(s, 42);
    assert(i == 3);

    i := search_seq(s, 55);
    assert(i == 8);

    i := search_seq(s, -2);
    assert(i == 1);
}


method main()
{
    var aseq := [100, -2, 300, 42, 42, -2, 200, 42, 55, 0];
 
    verify_search_seq(aseq);
}    
