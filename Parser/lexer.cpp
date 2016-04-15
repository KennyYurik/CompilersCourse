#include <exception>
#include <string>
#include <vector>
#include <fstream>
using namespace std;

/*class compilation_error : public exception {
	streampos pos;
	compilation_error(string s, streampos pos) : exception(), pos(pos) {
		
	}
};*/

struct Token {
	enum TokenType {
		COMMA, SMCLN, ASSIGN, EQ, GR, LESS, GR_EQ, LESS_EQ, OP_PAR, CL_PAR,
		OP_BR, CL_BR, OP_SQR, CL_SQR, PLUS, MINUS, MULT, DIV, OR, NOT, AND,
		TYPE, RETURN, IF, ELSE, WHILE, NUMBER, NAME
	};
	TokenType type;
	string value;
};

class LexAnalizer {
public:
	vector<Token> tokenstream;

	LexAnalizer(string filename) {
		ifstream in(filename);
		string s;
		vector<Token> samples = { { Token::COMMA, "," }, { Token::SMCLN, ";" }, { Token::EQ, "==" }, 
		{ Token::ASSIGN, "=" }, { Token::GR_EQ, ">=" },	{ Token::LESS_EQ, "<=" }, { Token::GR, ">" },
		{ Token::LESS, "<" }, { Token::OP_PAR, "(" }, { Token::CL_PAR, ")" }, { Token::OP_BR, "{" },
		{ Token::CL_BR, "}" }, { Token::OP_SQR, "[" }, { Token::CL_SQR, "]" }, { Token::PLUS, "+" },
		{ Token::MINUS, "-" }, { Token::MULT, "*" }, { Token::DIV, "/" }, { Token::OR, "|" }, { Token::NOT, "!" },
		{ Token::AND, "&" }, { Token::RETURN, "return" }, { Token::IF, "if" }, { Token::ELSE, "else" },
		{ Token::WHILE, "while" }, { Token::TYPE, "int" }, { Token::TYPE, "void" } }; // all without number, name 
		while (in >> skipws >> s) {
			int pos = 0;
			while (pos < s.size()) {
				bool match = false;
				for (auto token : samples) {
					if (s.substr(pos, token.value.size()) == token.value) {
						tokenstream.push_back(token);
						pos += token.value.size();
						match = true;
						break;
					}
				}
				//name
				if (!match && isalpha(s[pos])) {
					int endpos = pos;
					while (endpos < s.size() && (isalpha(s[endpos]) || isdigit(s[endpos]))) {
						++endpos;
					}
					string name = s.substr(pos, endpos - pos);
					tokenstream.push_back({ Token::NAME, name });
					pos = endpos;
					continue;
				}
				//number
				if (!match && isdigit(s[pos])) {
					int endpos = pos;
					int ans = 0;
					while (endpos < s.size() && isdigit(s[endpos])) {
						ans *= 10;
						ans += s[endpos] - '0';
						++endpos;
					}
					tokenstream.push_back({ Token::NUMBER, to_string(ans) });
					pos = endpos;
					continue;
				}
				// parse error
				if (!match)
					throw exception("wrong character");
			}
		}
	}
};

void main() {
	ofstream out("out.txt");
	LexAnalizer LA("input.txt");
	for (auto token : LA.tokenstream) {
		out << token.value << endl;
	}
}