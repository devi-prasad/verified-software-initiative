/**
 * Instruction to run simulation:
 *     spin -cC synkit.pml
 * Instructions for model checking:
 *     spin -a synkit.pml; cc -DSAFETY pan.c -o pan; pan;
 * In case verification fails, check the trace with:
 *     spin -cC -k synkit.pml.trail synkit.pml
 *
**/

mtype = { HI, DATA, DONE, ABORT }
mtype = { OK, RESET }
mtype = { STOP }

proctype cstore_server(chan cstore)
{
    chan client;

end:    
    do
    :: cstore?HI(client)    -> {
        client!OK;
    }
    :: cstore?DATA(client)  -> {
        do
        :: true -> client!OK; break;
        :: true -> client!RESET; break;
        od
    }
    :: cstore?ABORT(client) -> {
        client!OK;
    }
    :: cstore?DONE(client)  -> {
        client!OK;
    }
	:: true -> skip;
    od
}

bool reset = false;
proctype user(chan cstore) provided (reset == false)
{
    chan client = [1] of { mtype };

	cstore!HI(client);
	client?OK;

	do
    :: cstore!DATA(client)  -> {
        do
        :: client?OK    -> break;
        :: client?RESET -> { reset = true; break; }
        od
    }
	:: cstore!ABORT(client) -> { 
	    client?OK;
	    break;
	}
	:: cstore!DONE(client)  -> { 
	    client?OK;
	    break;
	}
	:: true -> skip;
	od
end:    
}


init {
    chan server = [1] of { mtype, chan };

    run cstore_server(server);
    run user(server);
//    run user(server);
}
