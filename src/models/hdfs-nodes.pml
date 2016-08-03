/**
 * Instruction to run simulation:
 *     spin -cC hdfs-nodes.pml
 * Instructions for model checking:
 *     spin -a hdfs-nodes.pml; cc -DSAFETY pan.c -o pan; pan;
 *     spin -cC -k hdfs-nodes.pml.trail hdfs-nodes.pml
 *
**/

mtype = { JOIN, HANDSHAKE, HEARTBEAT, DEAD }
mtype = { OK }

proctype namenode(chan master)
{
    byte dn;
    chan ch;
    byte dn_id = 0;
    byte dnodes = 0;

end:
    do
    :: master?JOIN(dn, ch) -> {
      dn_id++;
      dnodes++;
      printf("server: %d\n", dn_id)
      ch!OK(dn_id, 0)
    }
    :: master?HEARTBEAT(dn, ch) -> {
        ch!OK(dn, 0)
    }
    :: master?DEAD(dn, 0) -> {
        dnodes--;
        if
        :: (dnodes == 0) -> break;
        :: else -> skip;
        fi
    }
    od
}

proctype datanode(chan master)
{
    chan me = [1] of { mtype, byte, chan }
	byte myid;

	master!JOIN(_pid, me);
	me?OK(myid, 0);

	do
	:: master!HEARTBEAT(myid, me) -> me?OK(myid, 0);
	:: master!DEAD(myid, 0); break;
	:: true -> skip;
	od
}

init {
    chan master = [1] of { mtype, byte, chan };
	
	run namenode(master);
	run datanode(master);
    run datanode(master);
}

/**
  Check - what is the effect of altering the rule in line 47 so that
        the OK response from the server is handled separately in an action
        of its own, as shown below?
    do
    :: master!HEARTBEAT(myid, me);
    :: master!DEAD(myid, 0); break;
    :: me?OK(myid, 0);
    :: true -> skip;
    od
**/

/**
  Check - what is the effect of running another instance of the datanode
        process on a new line 59?
        Can you reason about the system before simulating and model checking?
**/
