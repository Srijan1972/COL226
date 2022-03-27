structure Tokens = Tokens
    type pos = int
    type svalue = Tokens.svalue
    type ('a,'b) token = ('a,'b) Tokens.token
    type lexresult = (svalue, pos) token
    val lineno = ref 1
    val colno = ref 0
    val pos = ref 1
    val eof = fn () => Tokens.EOF(!pos,!pos)
    val error = fn (e,l,c) => (print("Error at line " ^Int.toString(l)^", character"^Int.toString(c)^": "^e^"\n"); raise lexErr("Lexing error at line "^Int.toString(l)^", character "^Int.toString(c)^": "^e^"\n"))

%%
%header (functor whileLexFun(structure Tokens:while_TOKENS));
ws = [\ \t];
alpha = [A-Za-z];
digit = [0-9];

%%
"\n" => (lineno:=(!lineno)+1; colno:=0; pos:=(!pos)+1; lex());
{ws}+ => (lex());
"program" => (colno:=(!colno) + size yytext; Tokens.PROG(!lineno,!colno));
"::" => (colno:=(!colno) + size yytext; Tokens.CONS(!lineno,!colno));
"var" => (colno:=(!colno) + size yytext; Tokens.VAR(!lineno,!colno));
":" => (colno:=(!colno) + size yytext; Tokens.COLON(!lineno,!colno));
";" => (colno:=(!colno) + size yytext; Tokens.SEMICOLON(!lineno,!colno));
"int" => (colno:=(!colno) + size yytext; Tokens.INT(!lineno,!colno));
"bool" => (colno:=(!colno) + size yytext; Tokens.BOOL(!lineno,!colno));
"," => (colno:=(!colno) + size yytext; Tokens.COMMA(!lineno,!colno));
"{" => (colno:=(!colno) + size yytext; Tokens.LBRACE(!lineno,!colno));
"}" => (colno:=(!colno) + size yytext; Tokens.RBRACE(!lineno,!colno));
":=" => (colno:=(!colno) + size yytext; Tokens.ASSIGN(!lineno,!colno));
"read" => (colno:=(!colno) + size yytext; Tokens.READ(!lineno,!colno));
"write" => (colno:=(!colno) + size yytext; Tokens.WRITE(!lineno,!colno));
"if" => (colno:=(!colno) + size yytext; Tokens.IF(!lineno,!colno));
"then" => (colno:=(!colno) + size yytext; Tokens.THEN(!lineno,!colno));
"else" => (colno:=(!colno) + size yytext; Tokens.ELSE(!lineno,!colno));
"endif" => (colno:=(!colno) + size yytext; Tokens.ENDIF(!lineno,!colno));
"while" => (colno:=(!colno) + size yytext; Tokens.WHILE(!lineno,!colno));
"do" => (colno:=(!colno) + size yytext; Tokens.DO(!lineno,!colno));
"endwh" => (colno:=(!colno) + size yytext; Tokens.ENDWH(!lineno,!colno));
"(" => (colno:=(!colno) + size yytext; Tokens.LPAREN(!lineno,!colno));
")" => (colno:=(!colno) + size yytext; Tokens.RPAREN(!lineno,!colno));
"~" => (colno:=(!colno) + size yytext; Tokens.NEGATE(!lineno,!colno));
"||" => (colno:=(!colno) + size yytext; Tokens.OR(!lineno,!colno));
"&&" => (colno:=(!colno) + size yytext; Tokens.AND(!lineno,!colno));
"tt" => (colno:=(!colno) + size yytext; Tokens.VOLT(true,!lineno,!colno));
"ff" => (colno:=(!colno) + size yytext; Tokens.VOLT(false,!lineno,!colno));
"!" => (colno:=(!colno) + size yytext; Tokens.NOT(!lineno,!colno));
"<" => (colno:=(!colno) + size yytext; Tokens.LT(!lineno,!colno));
"<=" => (colno:=(!colno) + size yytext; Tokens.LEQ(!lineno,!colno));
"=" => (colno:=(!colno) + size yytext; Tokens.EQ(!lineno,!colno));
">" => (colno:=(!colno) + size yytext; Tokens.GT(!lineno,!colno));
">=" => (colno:=(!colno) + size yytext; Tokens.GEQ(!lineno,!colno));
"<>" => (colno:=(!colno) + size yytext; Tokens.NEQ(!lineno,!colno));
"+" => (colno:=(!colno) + size yytext; Tokens.PLUS(!lineno,!colno));
"-" => (colno:=(!colno) + size yytext; Tokens.MINUS(!lineno,!colno));
"*" => (colno:=(!colno) + size yytext; Tokens.TIMES(!lineno,!colno));
"/" => (colno:=(!colno) + size yytext; Tokens.DIV(!lineno,!colno));
"%" => (colno:=(!colno) + size yytext; Tokens.MOD(!lineno,!colno));
{alpha}({alpha}|{digit})* => (colno:=(!colno) + size yytext; Tokens.ID(yytext,!lineno,!colno));
["~"]?{digit}+ => (colno:=(!colno) + size yytext; Tokens.NUM(valOf(Int.fromString(yytext)),!lineno,!colno));
. => (error(yytext,!lineno,!colno) lex());