# Task

* write a compiler for simple language
* 1st half-term: specification, semantic, syntax, parser
* 2nd half-term: AST-tree, asm code, optimizations

# Project structure
* [Mylang.xtext](../master/workspace/org.xtext.example.mylang/src/org/xtext/example/Mylang.xtext) - grammar + tokens
* [MylangGenerator.xtend](../master/workspace/org.xtext.example.mylang/src/org/xtext/example/generator/MylangGenerator.xtend) - traversing over AST
* [test programs](../master/test_workspace/tests) - .lang files, description inside each file
* [generated asm files](../master/test_workspace/tests/src-gen)
* [.exe](../master/test_workspace/tests) - generated exec files with "make"
* [makefile](../master/test_workspace/tests/makefile) - script for gnu make

# Language description
* simple language based on C
* types: int, void
* variables
   * same names do not allow in scope
* declaration 
   `int a;` (only one variable in line)
* allows arrays (size = const)
   `int[4] a;` (a is array size of 4)
* functions 
   * like in C
   * declaration 
   `int func(int a, int b) { body }`
   * calling 
   `b = func(1, 2);`
* while
  `while (a > b) { body }`
* if
  `if (a == b) { body1 } else { body2 }` (else clause is unnesessary)
* global variables are initializing with 0, local are not initializing
* functions `a = read()`, `write(a)`
* program starts its execution from `void main() {}` function
* operators
  * bool: &, |, ==, >=, <=, >, <, !=
  * int: +, -, *, /

## Implementation

* Implemented using [xtext](https://eclipse.org/Xtext/)
   * Building parser from .xtext grammar file
   * Execute tree traverse in MylangGenerator.xtend
   * Output files is tests/src-gen/%filename%.asm
   * If compilation error occured, %filename%-error.txt created with error description instead of .asm one
* Compiling .asm files via [yasm](http://yasm.tortall.net/)
