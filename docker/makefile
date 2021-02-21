LIBS=lib
FLAGS=-ldl -lfcgi -pthread -Wl,-rpath -Wl,/usr/lib
OBJECTS = \
	cgi_protocol.o \
	fcgi_protocol.o

hello: hello.f90 $(OBJECTS)
	gfortran -o $@ $^ $(FLAGS) 

cgi_protocol.o: $(LIBS)/cgi/cgi_protocol.f90
	gfortran -c $<

fcgi_protocol.o: $(LIBS)/cgi/fcgi_protocol.f90
	gfortran -c $<
