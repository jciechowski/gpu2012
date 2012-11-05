CC=nvcc
SOURCES=mmul.cu
OBJECTS=$(SOURCES)
EXECUTABLE=mmul

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

mmul.o: mmul.cu
	$(CC) $(CFLAGS) $@

run:	all
	./$(EXECUTABLE)

clean: 
	rm -rf *.o mmul
