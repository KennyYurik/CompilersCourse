# Task

* write a compiler for simple language
* 1st half-term: specification, semantic, syntax, parser
* 2nd half-term: AST-tree, asm code, optimizations

# Project structure
* [Mylang.xtext](../master/org.xtext.example.mylang/src/org/xtext/example/Mylang.xtext) - grammar + tokens
* [MylangGenerator.xtend](../master/org.xtext.example.mylang/src/org/xtext/example/generator/MylangGenerator.xtend) - traversing over AST

# Language description
* simple language based on C
* types: int, void
* variables
   * same names do not allow in same scope vision
* declaration 
   `int a;` (only one variable in line)
* allows arrays (size = const)
   `int[4] a;` (a is array size of 4)
* functions 
   * like in C
   * declaration `int func(int a, int b) { body }`
   * calling `b = func(1, 2);`
* while
  `while (a > b) { body }`
* if
  `if (a == b) { body1 } else { body2 }` (else clause is unnesessary)
* allows nested blocks
* global variables are initializing with 0, local are not initializing
* functions `read(a)`, `write(a)`
* program starts its execution from `void main() {}` function

## Implementation

* Implemented using xtext
   * Building parser from .xtext grammar file
   * Execute tree traverse in MylangGenerator.xtend
   * Output file is %filename%.asm 

## Example
```
int m;
int fact1(int n) {
	if (n < 2) { return 1; }
	else { return n * fact1(n - 1); }
}
int fact2(int n) {
	int i;
	int ans;
	ans = 1;
	i = 1;
	while (i <= n) { ans = ans * i; i = i + 1; }
	return ans;
}
void main() {
	int a;
	int b;
	READ(m);
	a = fact1(m);
	WRITE(a);
	b = fact2(m);
	WRITE(b);
}
```
test