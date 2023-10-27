
default: mycp mymkdir mytouch mybasename

mybasename:
	cp `which basename` mybasename

mytouch:
	cp `which touch` mytouch

mycp: mycp.c
	gcc mycp.c -o mycp

mymkdir: mymkdir.c
	gcc mymkdir.c -o mymkdir

clean:
	rm -f mymkdir mycp mytouch mybasename
