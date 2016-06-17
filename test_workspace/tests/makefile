all: in-out factorials dijkstra
	
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
	
dijkstra: src-gen/dijkstra.asm
	mkdir build
	yasm -f win32 src-gen/dijkstra.asm -o build/dijkstra.o
	gcc build/dijkstra.o -o dijkstra.exe
	rm -r build
	