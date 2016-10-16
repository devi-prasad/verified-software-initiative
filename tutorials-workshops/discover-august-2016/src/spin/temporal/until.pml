//ltl trans { []!(p:A && p:B) }
//ltl trans { (p:A == true) U (p:B == true)}

ltl trans { []((A == true) U (B == true)) }


bool A = true, B = false, C = false, D = false;
active proctype p()
{

start:
    do
    :: (A == true) -> {
        printf("A\n");
        B = true;
        A = false;
    }
    :: (B == true) -> {
        assert(A == false);
        do
        :: true->skip;
        :: { A = true; B = false; C = true; break; }
        od
    }
/*    :: (C == true) -> {
        assert(A == false && B == false);
        do
        :: true->skip;
        :: { C = false; D = true; break; }
        od
    }
end:
    :: (D == true) -> {
        assert(A == false && B == false && C == false);
        printf("D\n");
        do
        :: true->skip;
        :: { D = false; A = true; break; }
        od
    }
*/    od
}
