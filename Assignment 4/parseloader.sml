Control.Print.printLength := 1000;
Control.Print.printDepth := 1000;
Control.Print.stringDepth := 1000;
CM.make("$/basis.cm");
CM.make("$/ml-yacc-lib.cm");
exception lexErr of string;
exception parseErr of string;
use "while_ast.sml";
use "while.yacc.sig";
use "while.yacc.sml";
use "while.lex.sml";

structure whileLrVals = whileLrValsFun(structure Token = LrParser.Token)
structure whileLex = whileLexFun(structure Tokens = whileLrVals.Tokens);
structure whileParser = Join(structure LrParser = LrParser structure ParserData = whileLrVals.ParserData structure Lex = whileLex)
     
fun invoke lexstream =
    let fun print_error (s,pos:int,_) = TextIO.output(TextIO.stdOut, "Error, line " ^ (Int.toString pos) ^ "," ^ s ^ "\n")
	in
	    whileParser.parse(0,lexstream,print_error,())
	end
		
fun parse (lexer) =
    let val dummyEOF = whileLrVals.Tokens.EOF(0,0)
    	val (result, lexer) = invoke lexer
	    val (nextToken, lexer) = whileParser.Stream.get lexer
    in
        if whileParser.sameToken(nextToken, dummyEOF) then result
 	else (TextIO.output(TextIO.stdOut, "Warning: Unconsumed input \n"); result)
    end

fun LexerFrFile f =
    let val inStream = TextIO.openIn f
		val str = TextIO.inputAll inStream 
        val _ = TextIO.closeIn inStream
        val done = ref false
        val lexer = whileParser.makeLexer (fn _ => if (!done) then "" else (done:=true;str))
    in
        lexer
    end

val parseIt = parse o LexerFrFile

fun aslt(filename):AST.command list=parseIt filename
