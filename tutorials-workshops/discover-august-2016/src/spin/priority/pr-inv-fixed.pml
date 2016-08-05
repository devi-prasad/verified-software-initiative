/**
 * Instruction to run simulation:
 *     spin -cC pr.pml
 * Instructions for model checking:
 *     spin -a pr-inv-fixed.pml; cc -DSAFETY pan.c -o pan; pan;
 * In case verification fails, check the trace with:
 *     spin -cC -k pr-inv-fixed.pml.trail pr-inv-fixed.pml
 *
**/

mtype = { free, busy };
mtype mutex = free;

/* pid of the process that locked the mutex */
byte mutex_owner;

/* the original priority of the process that locked the mutex */
byte mutex_priority;

inline lock() {
    atomic {
        do
        :: mutex == free -> {
           mutex = busy;
           mutex_owner = _pid;
           mutex_priority = _priority;
           break;
        }
        :: else -> {
            if
            :: get_priority(mutex_owner) < _priority -> {
               set_priority(mutex_owner, _priority);
               mutex == free
            }
            :: else
            fi
        }
       od
    }
}

inline unlock()
{
    mutex = free;
    mutex_owner = 0;
    _priority = mutex_priority
}

proctype high()
{
    printf("high scheduled\n")
    lock();

    /* critical section */
    assert(true);

    unlock()
}

proctype medium()
{
    end: do :: true -> skip od
}

active proctype low() priority 3 
{
    lock();

    run high() priority 7;
    run medium() priority 5;

    unlock();
    assert(true)
}
