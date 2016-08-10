
clean:
	rm -f pan* *.tmp *.trail

safe:
	spin -a sp-reset.pml; cc -DSAFETY -DNOREDUCE pan.c -o pan;

accept:
	spin -a sp-reset.pml; cc -DNOREDUCE pan.c -o pan;

pans:
	pan

pana:
	pan -a -N resetA
