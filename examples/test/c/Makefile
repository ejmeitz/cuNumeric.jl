all: libarray_allocator.so

libarray_allocator.so: randomarray.c
	gcc -O3 -march=native -flto -fPIC -Wall -Wextra -funroll-loops -fopenmp -shared -o libarray_allocator.so randomarray.c

clean:
	rm -f libarray_allocator.so