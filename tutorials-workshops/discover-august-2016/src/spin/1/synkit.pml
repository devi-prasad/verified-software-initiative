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


proctype cstore_server(chan cstore)
{
    chan client;

end:    
    do
    :: cstore?HI(client)    -> {
        client!OK;
    }
    :: cstore?DATA(client)  -> {
        client!OK;
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

proctype user(chan cstore)
{
    chan client = [1] of { mtype };

	cstore!HI(client);
	client?OK;

	do
	:: cstore!DATA(client)  -> { 
	    client?OK;
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
    run user(server);
}
