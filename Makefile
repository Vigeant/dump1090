CFLAGS?=-O2 -g -Wall -W $(shell pkg-config --cflags librtlsdr)
LDLIBS+=$(shell pkg-config --libs librtlsdr) -lpthread -lm
CC?=gcc
PROGNAME=dump1090

all: dump1090

%.o: %.c
	$(CC) $(CFLAGS) -c $<

dump1090: dump1090.o anet.o
	$(CC) -g -o dump1090 dump1090.o anet.o $(LDFLAGS) $(LDLIBS)

dump1090_afl: dump1090.c anet.c
	afl-gcc-fast -g -o dump1090_afl dump1090.c anet.c $(LDFLAGS) $(LDLIBS) -DAFL -no-pie 

dump1090_pwn: dump1090.c anet.c
	$(CC) -g -o dump1090_pwn dump1090.c anet.c -DAFL $(LDFLAGS) $(LDLIBS) -no-pie 

clean:
	rm -f *.o dump1090 dump1090_afl dump1090_pwn
