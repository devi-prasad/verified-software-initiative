/**
 * Instruction to run simulation:
 *     spin -cC sp-rest.pml
 * Instructions for model checking:
 *     spin -a sp-reset.pml; cc -DSAFETY pan.c -o pan; pan;
 *     spin -cC -k sp-reset.pml.trail sp-reset.pml
 *
**/

mtype = { REQ, RESET, BEGIN, DATA, DONE };

/*
 * We wish to express the requirement that once the client sends a RESET 
 * request, the server will eventually respond with a DONE message.
 *
 */
ltl resetA { []((client:reset_requested) -> <>(server:reset_served) )} 

#define there_is_data (server:size > server:cur)
ltl resetB { []((there_is_data && client:reset_requested) -> 
                                                  <>(server:reset_served) )} 


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
    byte size = 0, cur = 0;
    bool reset_served = false;
    
    xr req;
    xs resp;

end:
accept:
    do
    :: req?REQ(_) -> {
        reset_served = false;
        cur = 0;
        count_data_frames(size)
        resp!BEGIN(size);
    }
    :: req?RESET(_) -> {
        reset_served = true;
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
    bool reset_requested = false;
    int size = 0, prev = 0, cur = 0;
    bool idle = true;

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
        break;
    }
    :: (size > 0 && !reset_requested) -> {
        req!RESET(0);
        reset_requested = true;
    }
    od

end:
accept:
}

init {
    chan sresp = [1] of { mtype, int };
    chan creq  = [1] of { mtype, int };

    run client(creq, sresp);
	run server(creq, sresp);
}
