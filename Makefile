CC=g++
FLEX=flex
BISON=bison
	
.PHONY: clean
.lex: src/lex.l
	$(FLEX) -o src/lex.cpp src/lex.l
.syntax: src/syntax.y
	$(BISON) -o src/syntax.cpp -t -d -v src/syntax.y
splc: .lex .syntax src/main.cpp src/splc_log.cpp src/ir_code.cpp src/ast.cpp
	$(CC) -std=c++17 src/main.cpp src/splc_log.cpp src/ir_code.cpp src/ast.cpp -lfl -ly -o ./bin/splc
all: splc
clean:
	@rm -f bin/*
	@rm -f src/lex.cpp src/syntax.cpp src/syntax.hpp src/syntax.output
