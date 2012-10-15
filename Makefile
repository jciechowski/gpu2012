CC=nvcc
SOURCES=cuda01.cu
OBJECTS=$(SOURCES)
EXECUTABLE=main

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) 
	$(CC) $(CFLAGS) $(OBJECTS) -o $@

main.o: main.c
	$(CC) $(CFLAGS) $@

run:	all
	./$(EXECUTABLE)

clean: 
	rm -rf *.o main
