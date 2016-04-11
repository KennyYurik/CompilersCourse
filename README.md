# Task

* write a compiler for simple language
* 1st half-term: specification, semantic, syntax, parser
* 2nd half-term: AST-tree, asm code, optimizations

# Project structure
* [lexems.txt](../master/lexems.txt) - description of tokens
* [grammar.txt](../master/grammar.txt) - formal description of language rules
* TBD

# Language description
* simple language based on C
* types: bool, void, char, int
* declaration 
   `int a b c;` (without commas)
* allows arrays 
   `int[4] a b;` (a and b are two static arrays size of 4)
* functions 
   * declaration `a(int b int c int[5] d) int { body }` (without commas too, type before body)
   * return `return 1;`
   * calling `b = func(n, i, j, 14);` (with commas)
* while
  `while (a > b) { body }`
* if
  `if (a == b) { body1 } else { body2 }` (else clause is unnesessary)
* allows nested blocks
* user should initialize everything by himself
* functions `read(a)`, `write(a)`
* program starts its execution from `main() void {}` function

## Example
```
fact1(int n) int {
	if (n < 2) { return 1; }
	else { return n * fact1(n - 1); }
}
fact2(int n) int {
	int i ans;
	ans = 1;
	while (i <= n) { ans = ans * i; i = i + 1; }
	return ans;
}
main() void {
	int a b;
	read(n);
	b = fact1(n);
	write(b);
	b = fact2(n);
	write(b);
}
```
