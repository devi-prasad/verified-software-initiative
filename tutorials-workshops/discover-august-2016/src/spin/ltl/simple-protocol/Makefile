clean:
	rm -f pan* *.tmp *.trail

safe:
	spin -a sp.pml; cc -DSAFETY pan.c -o pan;

accept:
	spin -a sp.pml; cc -DNOREDUCE pan.c -o pan;

pans:
	pan

pana:
	pan -a
