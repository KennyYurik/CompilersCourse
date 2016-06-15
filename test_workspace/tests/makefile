all: in-out factorials
	
in-out: in-out.asm
	mkdir build
	yasm -f win32 src-gen/in-out.asm -o build/in-out.o
	gcc build/in-out.o -o in-out.exe
	rm -r build
	
factorials: factorials.asm
	mkdir build
	yasm -f win32 src-gen/factorials.asm -o build/factorials.o
	gcc build/factorials.o -o factorials.exe
	rm -r build