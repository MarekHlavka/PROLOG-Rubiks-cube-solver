# Prolog compiler command
PROLOG = swipl

# Source files
SRCS = main.pl input2.pl solve.pl cube_moves.pl

# Target executable
TARGET = flp22-log

# Default rule
all: $(TARGET)

# Rule to build the executable
$(TARGET): $(SRCS)
	$(PROLOG) -G16g -o $(TARGET) -g main -c $(SRCS)


# Rule to clean object files and executable
clean:
	rm -f $(TARGET)