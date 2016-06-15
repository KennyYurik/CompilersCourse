/*
 * generated by Xtext 2.10.0
 */
package org.xtext.example.generator

import java.util.List
import java.util.Map
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import org.xtext.example.mylang.AndExpr
import org.xtext.example.mylang.Assign
import org.xtext.example.mylang.Block
import org.xtext.example.mylang.CmpExpr
import org.xtext.example.mylang.Expression
import org.xtext.example.mylang.FinalExpr
import org.xtext.example.mylang.FunctionCall
import org.xtext.example.mylang.FunctionDecl
import org.xtext.example.mylang.If
import org.xtext.example.mylang.MulExpr
import org.xtext.example.mylang.PlusExpr
import org.xtext.example.mylang.Program
import org.xtext.example.mylang.Return
import org.xtext.example.mylang.TYPE
import org.xtext.example.mylang.VariableDecl
import org.xtext.example.mylang.While
import org.xtext.example.mylang.CMP_TYPE
import org.xtext.example.mylang.PLUS_TYPE
import org.xtext.example.mylang.MUL_TYPE

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
abstract class Name {		
	public TYPE type;
	public String name;
}


class Func extends Name {
	public List<Pair<TYPE,String>> args;
	
	new (TYPE type, String name, List<Pair<TYPE,String>> args) {
		this.type = type;
		this.name = name;
		this.args = args;
	}
} 

abstract class Var extends Name {
	public boolean isGlobal;
	public String pointer; // either name or ebp + offset
}

class Variable extends Var {
	
	new (TYPE type, String name, String pointer, boolean isGlobal) {
		this.type = type;
		this.name = name;
		this.pointer = pointer;
		this.isGlobal = isGlobal;
	}
} 

class Array extends Var {
	public int size;
	
	new(TYPE type, String name, String pointer, int size, boolean isGlobal) {
		this.type = type;
		this.name = name;
		this.size = size;
		this.pointer = pointer;
	}
}
	
class MylangGenerator extends AbstractGenerator {
	val String errVariableRedefine = "variable/function with the same name exist"
	val String errBadType = "Bad type"
	val String errNoMain = "No main() function"
	val String errArraySize = "Invalid Array Size"
	val String errBadEntity = "Assign or calling wrong entity"
	
	def String getLine(EObject e) {
		return " at line " + NodeModelUtils.getNode(e).startLine.toString;
	}
	
	var Map<String, Name> variables = newLinkedHashMap();

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		var tree = resource.contents;
		if (tree.size == 1) {
			var e = tree.get(0);
			if (e instanceof Program) {
				try {
					fsa.generateFile(resource.URI.lastSegment.replace(".lang", ".asm"), e.walk);
					
				} catch (Exception exp) {
					fsa.generateFile(resource.URI.lastSegment.replace(".lang", "-error.txt"), exp.message);
					
				}
			}
		}
	}
	
	def String walk(Program p) {
		var String ans = '''
		extern _printf, _scanf
		section .data
			int_format_in db "%d", 0
			int_format_out db "%d", 10, 0
		'''
		for (decl : p.declarations) {
			if (decl instanceof VariableDecl) {
				if (variables.containsKey(decl.name)) {
					throw new Exception(errVariableRedefine + getLine(decl));
				}
				if (decl.type != TYPE.INTEGER) {
					throw new Exception(errBadType + getLine(decl));
				}
				ans += "\t" + decl.name;
				if (decl.array) {
					if (decl.size <= 0) {
						throw new Exception(errArraySize + getLine(decl));
					}
					variables.put(decl.name, new Array(decl.type, decl.name, decl.name, decl.size, true));
					ans += " times " + decl.size;
				} else {
					variables.put(decl.name, new Variable(decl.type, decl.name, decl.name, true));
				}
				ans +=  " dd 0\n"
			}	
		}
		ans += '''
		section .text
		global _main
		 _write:
			mov eax, [esp + 4]
			push eax
			push int_format_out
			call _printf
			add esp, 8
			ret
			
		_read:
			sub esp, 4
			mov [esp], esp
			push int_format_in
			call _scanf
			mov eax, [esp + 4]
			add esp, 8
			ret
			
		'''
		variables.put("write", new Func(TYPE.VOID, "write", newLinkedList(new Pair(TYPE.INTEGER, "arg"))));
		variables.put("read", new Func(TYPE.INTEGER, "read", newLinkedList()));
		for (decl : p.declarations) {
			if (decl instanceof FunctionDecl) {
				if (variables.containsKey(decl.name)) {
					throw new Exception(errVariableRedefine + getLine(decl));
				}
				var List<Pair<TYPE, String>> args = newLinkedList();
				for (arg : decl.argList) {
					args.add(new Pair(arg.type, arg.name));
				}
				variables.put(decl.name, new Func(decl.type, decl.name, args));
			}	
		}
		if (!(variables.get("main") instanceof Func)) {
			throw new Exception(errNoMain);
		}
		for (decl : p.declarations) {
			if (decl instanceof FunctionDecl) {
				ans += "_" + decl.name + ':\n';
				ans += walk(decl);
			}
		}
		variables.clear
		ans;
	}
	
	//functions take its args from stack and return value int eax
	def String walk(FunctionDecl e) {
		var ans = "\tpush ebp\n"
		ans += "\tmov ebp, esp\n"
		var List<String> scope = newLinkedList();
		var int offset = 0;
		for (arg : e.argList) {
			if (arg.type != TYPE.INTEGER) {
				throw new Exception(errBadType + getLine(arg));
			}
			if (variables.containsKey(arg.name)) {
				throw new Exception(errVariableRedefine + getLine(arg));
			}
			scope.add(arg.name);	
			variables.put(arg.name, new Variable(arg.type, arg.name, "ebp - " + (offset + 1) * 4, false));
			offset++
		}
		if (offset > 0) {
			ans += "\tsub esp, " + offset * 4 + "\n";
		}
		ans += walk(e.body, "_" + e.name, offset);
		for (variable : scope) {
			variables.remove(variable)
		}
		if (offset > 0) {
			ans += "\tadd esp, " + offset * 4 + "\n"
		}
		ans += "\tpop ebp\n";
		ans += "\tret\n\n";
		ans		
	}
	
	def String walk(Block e, String mark, int old_offset) {
		var int offset = 0;
		var List<String> scope = newLinkedList();
		var String ans = "";
		var ifCounter = 0;
		var whileCounter = 0;
		for (command : e.commands) {
			switch command {
				VariableDecl: {
					if (variables.containsKey(command.name)) {
						throw new Exception(errVariableRedefine + getLine(command));
					}
					scope.add(command.name);
					if (command.isArray) {
						if (command.size <= 0) {
							throw new Exception(errArraySize + getLine(command));
						}	
						variables.put(command.name,
							new Array(command.type, command.name, "ebp - " + (old_offset + offset + 1) * 4, command.size, false)
						)
						offset += command.size;
						ans += "\tsub esp, " + command.size + "\n";
					} else {
						variables.put(command.name, 
						new Variable(command.type, command.name, "ebp - " + (old_offset + offset + 1) * 4, false)
						);
						offset++;
						ans += "\tsub esp, 4\n";
					}
				}
				Assign: {
					ans += walk(command.expression);
					if (command.isArray) {
						var arr = variables.get(command.name);
						if (arr instanceof Array) {
							ans += walk(command.index);
							ans += "\tpop ebx\n"
							ans += "\tadd ebx, " + arr.pointer.substring(6) + "\n"
							ans += "\tpop eax\n"
							ans += "\tmov [ebp - ebx], eax\n" 
						} else {
							throw new Exception(errBadEntity + getLine(command));
						}
					} else {
						if (variables.get(command.name) instanceof Variable) {
							ans += "\tpop eax\n"
							var String pointer = (variables.get(command.name) as Variable).pointer;
							ans += "\tmov [" + pointer + "], eax\n"
						} else {
							throw new Exception(errBadEntity + getLine(command));
						}
					}
				}
				If: {
					ifCounter++
					ans += walk(command.condition)
					ans += "\tpop eax\n"
					ans += "\tcmp eax, 1\n"
					ans += "\tjne "
					if (command.isElse) {
						ans += mark + "_else" + ifCounter + "\n";
						ans += walk(command.body, mark + "_if" + ifCounter, old_offset + offset)
						ans += "\tjmp " + mark + "_endif" + ifCounter + "\n"
						ans += mark + "_else" + ifCounter + ":\n"
						ans += walk(command.elseBody, mark + "_else" + ifCounter, old_offset + offset)
					} else {
						ans += mark + "_endif" + ifCounter + "\n"
						ans += walk(command.body, mark + "_if" + ifCounter, old_offset + offset)
					}
					ans += mark + "_endif" + ifCounter + ":\n";
				}
				While: {
					whileCounter++;
					ans += mark + "_while" + whileCounter + ":\n"
					ans += walk(command.condition);
					ans += "\tpop eax\n"
					ans += "\tcmp eax, 1\n"
					ans += "\tjne " + mark + "_endwhile" + whileCounter + "\n"
					ans += walk(command.body, mark + "_while" + whileCounter, old_offset + offset)
					ans += mark + "_endwhile" + whileCounter + ":\n"
				}
				Return: {
					if (command.value != null) {
						ans += walk(command.value);
						ans += "\tpop eax\n";
					}
					if (old_offset + offset > 0) {
						ans += "\tadd esp, " + (old_offset + offset) * 4 + "\n"	
					}
					ans += "\tpop ebp\n"
					ans += "\tret\n"
				}
				FunctionCall: {
					ans += walk(command)
					ans += "\tpop eax\n"
				}
			}
		}
		for (variable : scope) {
			variables.remove(variable)
		}
		if (offset > 0) {
			ans += "\tadd esp, " + offset * 4 + "\n"
		}
		return ans
	}
	
	//push its result on stack (4 bytes)
	def String walk(Expression e) {
		var String ans = walk(e.first)
		for (expr : e.expr) {
			ans += walk(expr);
			ans += "\tpop eax\n"
			ans += "\tor [esp], eax\n"
		}
		return ans
	}
	
	//push its result on stack (4 bytes)
	def String walk(AndExpr e) {
		var String ans = walk(e.first)
		for (expr : e.expr) {
			ans += walk(expr);
			ans += "\tpop eax\n"
			ans += "\tand [esp], eax\n"
		}
		return ans
	}
	
	// push its result on stack (4 bytes)
	def String walk(CmpExpr e) {
		var String ans = walk(e.first)
		if (e.second != null) {
			ans += walk(e.second)
			ans += "\tpop eax\n"
			ans += "\tpop ebx\n"
			ans += "\txor edx, edx\n"
			ans += "\tcmp eax, ebx\n"
			ans +=  "\tset" + switch e.type {
				case CMP_TYPE.EQ: "e"
				case CMP_TYPE.GR: "g"
				case CMP_TYPE.LESS: "l"
				case CMP_TYPE.NEQ: "ne"
				case CMP_TYPE.NGR: "ng"
				case CMP_TYPE.NLESS: "nl"
			} + " dl\n"
			ans += "\tpush edx\n"
		}
		ans
	}
	
	// push its result on stack (4 bytes)
	def String walk(PlusExpr e) {
		var String ans = walk(e.first)
		for (var i = 0; i < e.expr.size; i++) {
			var expr = e.expr.get(i);
			var type = e.type.get(i);
			ans += walk(expr);
			ans += "\tpop eax\n"
			if (type == PLUS_TYPE.MINUS) {
				ans += "\tsub [esp], eax\n"
			} else {
				ans += "\tadd [esp], eax\n"
			}	
		}
		return ans
	}
	
	// push its result on stack (4 bytes)
	def String walk(MulExpr e) {
		var String ans = walk(e.first)
		for (var i = 0; i < e.expr.size; i++) {
			var expr = e.expr.get(i);
			var type = e.type.get(i);
			ans += walk(expr);
			ans += "\tpop ebx\n"
			ans += "\tpop eax\n"
			if (type == MUL_TYPE.MUL) {
				ans += "\tmul ebx\n"
			} else {
				ans += "\txor edx, edx\n"
				ans += "\tdiv ebx\n"
			}	
			ans += "\tpush eax\n"
		}
		return ans
	}
	
	def String walk(FinalExpr e) {
		if (e instanceof FunctionCall) {
			return walk(e)
		} else if (e.expr != null) {
			return walk(e.expr);
		} else if (e.variable != null) {
			if (e.isArray) {
				var String ans = ""
				var arr = variables.get(e.variable);
				if (arr instanceof Array) {
					ans += walk(e.index);
					ans += "\tpop ebx\n"
					ans += "\tadd ebx, " + arr.pointer.substring(6) + "\n"
					ans += "\tmov eax, [ebp - ebx]\n"
					ans += "\tpush eax\n" 
				} else {
					throw new Exception(errBadEntity + getLine(e));
				}
			} else {
				var String ans = "";
				var variable = variables.get(e.variable)
				if (variable instanceof Variable) {
					var String pointer = (variable).pointer;
					ans += "\tmov eax, [" + pointer + "]\n"
					ans += "\tpush eax\n"
				} else {
					throw new Exception(errBadEntity + getLine(e));
				}
			}
		} else {
			var String ans = "\tmov eax, " + e.number + "\n"
			ans += "\tpush eax\n"
			return ans;
		}
	}
	
	def String walk(FunctionCall e) {
		var String ans = ""
		for (arg : e.args.reverse) {
			ans += walk(arg);
		}
		ans += "\tcall _" + e.name + "\n";
		ans += "\tadd esp, " + (4 * e.args.size) + "\n";
		ans += "\tpush eax\n"
		ans
	}
} 
