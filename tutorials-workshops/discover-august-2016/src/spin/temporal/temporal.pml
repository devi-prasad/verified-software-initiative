/*
 * run the verifier: spin -a temporal.pml; cc -DSAFETY pan.c -o pan; pan;
 * debug trail: spin -cC -p -l -t -k temporal.pml.trail temporal.pml
 */ 

//ltl trans { []!(A && B) }
//ltl trans { (A U B) }
//ltl trans { [] (A U B) }
//ltl { !(A -> B) }

bool A = true;
bool B = false;

active proctype p()
{
    do
    :: (A == true) -> {
        assert(B == false);
        A = false;
        B = true;
    }
    :: (A == true) -> skip;

    :: (B == true) -> { assert(A == false); skip; }
    :: (B == true) -> {
        B = false;
        A = true;
    }
    od
}
