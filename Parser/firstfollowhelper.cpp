#include <fstream>
#include <string>
#include <iostream>
#include <vector>
#include <map>
#include <sstream>
#include <set>
using namespace std;
typedef vector<string> Rule; // Rule: -> term1 term2 term3


map<string, vector<Rule>> rules;
map<string, set<string>> FIRST;
map<string, set<string>> FOLLOW;
set<string> terms;
map<string, map<string, Rule>> table;

template<class C, class T> 
bool contains(C& container, T& elem) {
	return find(begin(container), end(container), elem) != end(container);
}

// get FIRST set of (X1 X2 X3...)
set<string> first(vector<string>& v){
	set<string> res;
	bool containseps = true;
	for (auto& nterm : v) {
		res.insert(FIRST[nterm].begin(), FIRST[nterm].end());
		if (!contains(FIRST[nterm], "EPS")) {
			containseps = false;
			break;
		}
	}
	if (containseps)
		res.insert("EPS");
	else
		res.erase("EPS");
	return res;
}



void initFIRSTset(){
	for (auto& term : terms) {
		 FIRST[term].insert(term);
	}
	bool changed = true;
	while (changed) { // modify while something changes
		changed = false;
		for (auto& entry : rules){
			for (auto& rule : entry.second){ // X -> rule
				int depth = 0;
				for (auto& nterm : rule) {	// add all FIRST(nterm) into X
					for (auto term : FIRST[nterm]) {
						if (FIRST[entry.first].insert(term).second)
							changed = true;
					}
					if (!contains(FIRST[nterm], "EPS"))
						break;
					++depth;
				}
				if (depth == rule.size()) { // add eps to X
					if (FIRST[entry.first].insert("EPS").second)
						changed = true;
				}
			}
		}
	}
}

void initFOLLOWset() {
	FOLLOW["program"].insert("END");
	bool changed = true;
	while (changed) { // modify while something changes
		changed = false;
		for (auto& entry : rules){
			for (auto& rule : entry.second){ // for each X -> rule
				for (auto it = rule.begin(); it != rule.end(); ++it) {
					if (islower(it->at(0))) { // if current nterm is NONTERMINAL
						// X -> alpha IT betta
						auto first_betta = first(vector<string>(it + 1, rule.end()));
						int oldsize = FOLLOW[*it].size();
						FOLLOW[*it].insert(first_betta.begin(), first_betta.end()); //add all first_betta to FOLLOW(IT)
						if (contains(first_betta, "EPS")) { // if eps add all FOLLOW(X) to FOLLOW(IT)
							FOLLOW[*it].erase("EPS");
							FOLLOW[*it].insert(FOLLOW[entry.first].begin(), FOLLOW[entry.first].end());
						}
						if (oldsize < FOLLOW[*it].size())
							changed = true;
					}
				}
			}
		}
	}
}

void inittable() {
	for (auto& entry : rules) {
		for (auto& rule : entry.second) {
			//for each X -> alpha
			auto FIRSTalpha = first(rule);
			for (auto& term : FIRSTalpha) {
				if (table[entry.first].find(term) != table[entry.first].end()) {
					//cerr << "qqq";
					exit(1);
				}
				table[entry.first][term] = rule;
			}
			if (contains(FIRSTalpha, "EPS")) {
				for (auto& term : FOLLOW[entry.first]) {
					if (table[entry.first].find(term) != table[entry.first].end()) {
						cerr << "qqq";
						exit(1);
					}
					table[entry.first][term] = rule;
				}
			}
		}
	}
}

int main() {
	ifstream in("grammar.in");
	ofstream out("out.txt");
	string s;
	while (getline(in, s)) {
		stringstream ss(s);
		string left, tmp;
		ss >> left >> tmp;
		if (tmp != "=")
			return 1;
		while (1) {
			vector<string> rule;
			ss >> tmp;
			if (tmp == "(") {
				vector<string> or;
				while (ss >> tmp && tmp != ")") {
					if (tmp != "|")
						or.push_back(tmp);
				}
				rule.push_back("");
				while (ss >> tmp && tmp != "|") {
					rule.push_back(tmp);
				}
				for (int i = 0; i < or.size(); i++) {
					rule[0] = or[i];
					rules[left].push_back(rule);
				}
			}
			else {
				if (tmp != "EPS")
					rule.push_back(tmp);
				while (ss >> tmp && tmp != "|") {
					rule.push_back(tmp);
				}
				rules[left].push_back(rule);
			}
			if (!ss)
				break;
		}
	}

	for (auto pair : rules) {
		for (auto rule : pair.second) {
			//out << pair.first << "->";
			for (auto s : rule) {
				//out << s << " ";
				if (isupper(s[0]))
					terms.insert(s);
			}
			//out << endl;
		}
	}
	//out << "\n\n\n\n";
	initFIRSTset();
	initFOLLOWset();
	inittable();
	
	return 0;
}