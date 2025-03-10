all: build
build: 
	g++ -shared -fPIC -o libcallback.so callback.cc -I.
test: 
	./callback 
clean:
	rm *.so
	rm *.txt
	rm *.log
