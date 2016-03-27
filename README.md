Task: 
	*write a compiler for simple language
	*1st half-term: specification, semantic, syntax, parser
	*2nd half-term: AST-tree, asm code, optimizations

Project structure:
	*lexems.txt - description of tokens
	*grammar.txt - formal description of language rules
	*TBD

Language description:
	*simple language based on C
	
	*types: bool, void, char, int
	
	declaration: 
		"int a b c;" // without commas
	
	allows arrays: 
		"int[4] a b;" // a and b are two static arrays size of 4
	
	functions: 
		"int a(int b int c int[5] d){ body }" // without commas too
		returning with "return 1;"
		b = func(n, i, j, 14) //calling with commas

	while:
		"while (a > b) { body }"
	
	for:
		"for (i, a+b, 2)" // i goes from a+b to 2 with step = 1
	
	if:
		"if (a == b) { body1 } else { body2 }" - else clause is unnesessary
	
	*allows nested blocks
	
	*user should initialize everything by himself, it doesnt check

	*functions read(a), write(a)

	*program starts execution from 'void main(){}' function

example:
	int fact1(int n) {
		if (n < 2) { return 1; }
		else { return n * fact1(n - 1); }
	}
	int fact2(int n) {
		int i ans;
		ans = 1;
		for (i, 1, n) { ans = ans * i; }
		return ans;
	}
	void main(){
		int a b;
		read(n);
		b = fact1(n);
		write(b);
		b = fact2(n);
		write(b);
	}
