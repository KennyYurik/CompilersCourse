#include <vector>
using namespace std;

class AbstractNode {
public:
	AbstractNode* parent;
};

class Terminal : public AbstractNode {

};

class Nonterminal : public AbstractNode {
public:
	vector<AbstractNode*> children;
};

class Node_expr : public Nonterminal {
public: 
	int accumulator;
};

class Node_expr2 : public Nonterminal {
public:
	int accumulator;
};

class Node_NUMBER : public Terminal {
	int value;
};

class AST {
	AbstractNode* root;
	vector<AbstractNode*> current;
	//+ table

	AST() {
		root = new Node_expr();
	}
	void add(lexem) {

	}
};