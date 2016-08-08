/**
 * Instruction to run simulation:
 *     spin -cC sp.pml
 * Instructions for model checking:
 *     spin -a sp.pml; cc -DSAFETY pan.c -o pan; pan;
 *     spin -cC -k sp.pml.trail sp.pml
 *
**/


mtype = { REQ, RESET, BEGIN, DATA, DONE };

inline count_data_frames(n)
{
    if
    :: true -> n = 2;
    :: true -> n = 5;
    :: true -> n = 9;
    :: true -> n = 11;
    fi
}

proctype server(chan conn) {
    int size = 0, cur = 0, resource;
    int i;

end:
    do
    :: conn?REQ(resource) -> {
        count_data_frames(size)
        cur = 0;
        conn!BEGIN(size)
    }
    :: conn?RESET(i) -> {
        conn!DONE(size - cur)
        break;
    }
    :: (cur < size) -> {
        cur++;
        conn!DATA(cur)
    }
    :: (size > 0 && cur == size) -> {
        conn!DONE(size - cur)
        break;
    }
    od
}

proctype client(chan conn)
{
    bool idle = true, reset_requested = false;
    int size = 0, prev = 0, cur = 0;

    do
    :: idle -> {
        conn!REQ(0);
        idle = false;
    }
    :: conn?BEGIN(size) -> {
        prev = 0;
        cur = 0;
    }
    :: conn?DATA(cur) -> {
        //assert(!reset_requested);
        assert(cur > prev);
        assert(cur <= size);
        prev = cur;
    }
    :: conn?DONE(cur) -> {
        idle = true;
        prev = 0;
        cur = 0;
        size = 0;
        break;
    }
    :: true -> skip;
    od

end:
}

init {
    chan conn = [4] of { mtype, int }

	run server(conn);
	run client(conn);
}