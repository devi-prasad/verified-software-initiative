/**
 * Instruction to run simulation:
 *     spin -cC sp-ltl.pml
 * Instructions for model checking:
 *     spin -a -o3 sp-ltl.pml; cc -DSAFETY pan.c -o pan; pan -a;
 *     spin -l -p -cC -k sp-ltl.pml.trail sp-ltl.pml
 *
**/


ltl p1 { []( (client:idle == false) -> <>(client:size > 0) ) }

mtype = { REQ, BEGIN, DATA, DONE };

inline count_data_frames(n)
{
    if
    :: n = 1
    :: n = 2;
    :: n = 5;
    fi
}

proctype server(chan conn) 
{
    byte size = 0, cur = 0;

end:
    do
    :: conn?REQ(_) -> {
        count_data_frames(size)
        cur = 0;
        conn!BEGIN(size)
    }
    :: (cur < size) -> {
        cur++;
        conn!DATA(cur)
    }
    :: (size > 0 && cur == size) -> {
        conn!DONE(cur)
        size = 0;
    }
    od
}

proctype client(chan conn)
{
    bool idle = true;
    byte size, cur, prev;

    do
    :: idle -> {
        conn!REQ(0);
        idle = false;
        size = 0;
    }
    :: conn?BEGIN(size) -> {
        cur = 0;
        prev = 0;
    }
    :: conn?DATA(cur) -> {
        assert(cur == prev + 1);
        assert(cur <= size);
        prev = cur;
    }
    :: conn?DONE(cur) -> {
        idle = true;
    }
    od

end:
}

init {
    chan conn = [4] of { mtype, int }

	run client(conn);
    run server(conn);
}
