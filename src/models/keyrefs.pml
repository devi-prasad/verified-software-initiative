unsigned next_random:5;

inline gen_random_byte(n)
{
	random_generator();
    n = next_random;
}

 inline random_generator()
{
    unsigned rn:5;
    do
    :: if :: (rn < 32) -> rn++; fi
    :: if :: (rn > 0) -> rn--; fi
    :: break;
    od

end_random:
    next_random = rn;
}

inline setkv(key, val)
{
    assert(key >= 0 && key < 5)
    refs++;
    printf("refs(add): %d\n", refs)

    if
    :: (data[key] == val) -> skip;
    :: else -> data[key] = val; refs--;
    fi
 
    printf("refs(sub): %d\n", refs)
}

active proctype keyring()
{
    unsigned refs:4 = 0;
    unsigned key:5, val:5;
    byte data[5] = { 0 };

    do
    :: break
    :: true -> {
       gen_random_byte(key)
       key = key % 5
       setkv(key, val)
    }
    od
    
    printf("final refs = %d\n", refs)
    assert(refs == 0)
}
