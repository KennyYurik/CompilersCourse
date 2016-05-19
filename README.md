# Task

* write a compiler for simple language
* 1st half-term: specification, semantic, syntax, parser
* 2nd half-term: AST-tree, asm code, optimizations

# Project structure
* [lexems.txt](../master/lexems.txt) - description of tokens
* [grammar.txt](../master/grammar.txt) - formal description of language rules
* [lexer.cpp](../master/Parser/lexer.cpp) - lexical analyzer (characters -> tokens)
* TBD

# Language description
* simple language based on C
* types: int, void
* variables - lowercase letters and digits
* declaration 
   `int a;` (only one variable in line)
* allows arrays 
   `int[4] a;` (a is static array size of 4)
* functions 
   * names - uppercase letters and digits
   * declaration `A(int b int c int[5] d) int { body }` (without commas, type before body)
   * return `return 1;`
   * calling `b = FUNC(n i j 14);` (without commas)
* while
  `while (a > b) { body }`
* if
  `if (a == b) { body1 } else { body2 }` (else clause is unnesessary)
* allows nested blocks
* user should initialize everything by himself
* functions `READ(a)`, `WRITE(a)`
* program starts its execution from `MAIN() void {}` function

## Example
```
FACT1(int n) int {
	if (n < 2) { return 1; }
	else { return n * FACT1(n - 1); }
}
FACT2(int n) int {
	int i;
	int ans;
	ans = 1;
	i = 1;
	while (i <= n) { ans = ans * i; i = i + 1; }
	return ans;
}
MAIN() void {
	int a b;
	READ(n);
	b = FACT1(n);
	WRITE(b);
	b = FACT2(n);
	WRITE(b);
}
```
test