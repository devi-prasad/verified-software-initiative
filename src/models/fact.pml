
byte result = 1;

proctype main(byte n)
{
	do
	:: if :: (n == 0) -> break; fi
	:: if
	   :: (n > 0) -> {
         result = result * n;
         n--;
	   }
	   fi
	od
}

init {
	run main(6)
}