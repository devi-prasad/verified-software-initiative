/**
 * Instruction to run simulation:
 *     spin -cC pr.pml
 * Instructions for model checking:
 *     spin -a pr.pml; cc -DSAFETY pan.c -o pan; pan;
 * In case verification fails, check the trace with:
 *     spin -cC -k pr.pml.trail pr.pml
 *
**/

mtype = { free, busy };
mtype mutex = free;

inline lock() { atomic { mutex == free -> mutex = busy } }
inline unlock() { mutex = free }

proctype high()
{
    lock();
    /* critical section */
    /* unreachable, because medium starves high */
    assert(false);
    unlock()
}

proctype medium()
{
end:
    do
    :: true -> skip 
    od
}

active proctype low() priority 3 
{
    lock();
    run high() priority 7;
    run medium() priority 5;
    /* unreachable because medium preempts low */
    /* critical section */
    unlock();
    assert(false)
}
