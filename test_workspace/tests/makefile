all: expression
	
in-out: src-gen/in-out.asm
	mkdir build
	yasm -f win32 src-gen/in-out.asm -o build/in-out.o
	gcc build/in-out.o -o in-out.exe
	rm -r build
	
factorials: src-gen/factorials.asm
	mkdir build
	yasm -f win32 src-gen/factorials.asm -o build/factorials.o
	gcc build/factorials.o -o factorials.exe
	rm -r build
	
expression: src-gen/expression.asm
	mkdir build
	yasm -f win32 src-gen/expression.asm -o build/expression.o
	gcc build/expression.o -o expression.exe
	rm -r build
	