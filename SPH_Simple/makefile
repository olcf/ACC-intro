CC=cc
CFLAGS=-O3 -c99 -Minline=levels:5

all: cpu acc omp

SRC:=	src/fileio.c \
	src/geometry.c

cpu: $(SRC)
	$(CC) $(CFLAGS) src/fluid.c $^ -o sph-cpu.out

acc: $(SRC)
	$(CC) $(CFLAGS) -acc -Minfo=acc -ta=tesla,cc35 src/fluid.c $^ -o sph-acc.out

omp: $(SRC)
	$(CC) $(CFLAGS) -mp src/fluid-omp.c $^ -o sph-omp.out

clean:
	rm -rf *.o *.out
