all: build
JULIA_DIR=$(shell which julia)
build: 
	# gcc -o callback -fPIC -I$(JULIA_DIR)/include/julia -L$(JULIA_DIR)/lib -Wl,-rpath,$(JULIA_DIR)/lib test.c -ljulia
	gcc -shared -fPIC -o callback.so callback.c 
test: 
	./callback 
clean:
	rm *.so
	rm *.txt
	rm *.log