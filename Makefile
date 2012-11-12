CC=nvcc
SOURCES=cudaMul.cu
OBJECTS=$(SOURCES)
EXECUTABLE=cudamul
CFLAGS=-Xcompiler -Wall

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

cudaMul.o: cudaMul.cu
	$(CC) $(CFLAGS) $@

run:	all
	./$(EXECUTABLE) 1024

clean: 
	rm -rf *.o cudamul
