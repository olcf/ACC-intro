CC=cc
CFLAGS=-O3 -c99 -Minline=levels:5

all: cpu acc omp

SRC:=	src/fluid.c  \
	src/fileio.c \
	src/geometry.c

cpu: $(SRC)
	$(CC) $(CFLAGS) $^ -o sph-cpu.out

acc: $(SRC)
	$(CC) $(CFLAGS) -acc -Minfo=acc -ta=tesla,cc35 $^ -o sph-acc.out

omp: $(SRC)
	$(CC) $(CFLAGS) -mp $^ -o sph-omp.out

clean:
	rm -rf *.o *.out
