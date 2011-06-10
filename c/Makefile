# Justin Ethier
# 
# Makefile for aes
# 
CFLAGS = -g -std=c99

# TODO: create a main aes executable
test: test.o aes.o
	gcc -o test-aes test.o aes.o
	./test-aes
test.o: test.c
	gcc $(CFLAGS) -c test.c
aes.o: aes.c
	gcc $(CFLAGS) -c aes.c

clean:
	rm -f *.o *.out test-aes
