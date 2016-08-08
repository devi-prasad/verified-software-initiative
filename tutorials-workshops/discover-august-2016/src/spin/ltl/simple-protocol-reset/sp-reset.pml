/**
 * Instruction to run simulation:
 *     spin -cC sp-rest.pml
 * Instructions for model checking:
 *     spin -a sp-reset.pml; cc -DSAFETY pan.c -o pan; pan;
 *     spin -cC -k sp-reset.pml.trail sp-reset.pml
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

proctype server(chan req; chan resp) {
    int size = 0, cur = 0;

    xr req;
    xs resp;

end:
    do
    :: req?REQ(_) -> {
        count_data_frames(size)
        cur = 0;
        resp!BEGIN(size);
    }
    :: req?RESET(_) -> {
        resp!DONE(cur)
        break;
    }
    :: (cur < size) -> {
        cur++;
        resp!DATA(cur)
    }
    :: (size > 0 && cur == size) -> {
        resp!DONE(cur)
        break;
    }
    od
}

proctype client(chan req; chan sresp)
{
    bool idle = true, reset_requested = false;
    int size = 0, prev = 0, cur = 0;

    xs req;
    xr sresp;

    do
    :: idle -> {
        req!REQ(0);
        idle = false;
    }
    :: sresp?BEGIN(size) -> {
        prev = 0;
        cur = 0;
    }
    :: sresp?DATA(cur) -> {
        assert(cur == prev + 1);
        assert(cur <= size);
        prev = cur;
    }
    :: sresp?DONE(cur) -> {
        idle = true;
        prev = 0;
        cur = 0;
        size = 0;
        break;
    }
    :: (size > 0 && !reset_requested) -> {
        req!RESET(0);
        reset_requested = true;
    }
    od

end:
}

init {
    chan sresp = [1] of { mtype, int };
    chan creq  = [1] of { mtype, int };

    run client(creq, sresp);
	run server(creq, sresp);
}
