CC=gcc
CFLAGS=-Wall -pedantic -DNDEBUG -lm
SOURCES=main.c
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
