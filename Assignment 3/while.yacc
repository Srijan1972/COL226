
%%
%term NUM of int | VOLT of bool | NOT | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ | NEGATE | PLUS | MINUS | TIMES | DIV | MOD | LPAREN | LBRACE | RPAREN | RBRACE | COLON | SEMICOLON | CONS | ASSIGN | COMMA | PROG | VAR | INT | BOOL | READ | WRITE | IF | THEN | ELSE | ENDIF | WHILE | DO | ENDWH | EOF | ID of string
%nonterm begin of AST.progop | block of AST.BLK | decseq of AST.decseq | dec of AST.dec | varType of AST.varType | vList of AST.vdec | comseq of AST.comseq | tempcom of AST.tempcom | com of AST.command | exp of AST.exp | var of AST.var
%pos int
%eop EOF 
%noshift EOF
%name while

%right IF THEN ELSE ENDIF WHILE DO ENDWH
%left LT LEQ EQ GT GEQ NEQ
%left OR
%left AND
%left PLUS MINUS
%left TIMES DIV MOD
%right NOT NEGATE
%verbose
%start begin

%%
begin: PROG ID CONS block (AST.PROG(ID,block))
block: decseq comseq (AST.BLK1(decseq,comseq)) | comseq (AST.BLK2(comseq))
decseq: dec (AST.DEC2(dec)) | decseq dec (AST.DEC1(dec,decseq))
dec: VAR vList COLON varType SEMICOLON (AST.decl(vList,varType))
varType: INT (AST.INT) | BOOL (AST.BOOL)
vList: var COMMA vList (AST.varde1(var,vList)) | var (AST.varde2(var))
comseq: LBRACE tempcom RBRACE (AST.temp(tempcom)) | LBRACE RBRACE (AST.empty)
tempcom: tempcom com (AST.com1(com,tempcom)) | com (AST.com2(com))
com: ID ASSIGN exp SEMICOLON (AST.SET(ID,exp))
    | READ ID SEMICOLON (AST.READ(ID))
    | WRITE exp SEMICOLON (AST.WRITE(exp))
    | IF exp THEN comseq ELSE comseq ENDIF SEMICOLON (AST.ITE(exp,comseq1,comseq2))
    | WHILE exp DO comseq ENDWH SEMICOLON (AST.WH(exp,comseq))
exp: exp PLUS exp (AST.binExp(exp1,AST.PLUS,exp2))
    | exp TIMES exp (AST.binExp(exp1,AST.TIMES,exp2))
    | exp DIV exp (AST.binExp(exp1,AST.DIV,exp2))
    | exp MOD exp (AST.binExp(exp1,AST.MOD,exp2))
    | exp AND exp (AST.binExp(exp1,AST.AND,exp2))
    | exp OR exp (AST.binExp(exp1,AST.OR,exp2))
    | exp LT exp (AST.binExp(exp1,AST.LT,exp2))
    | exp LEQ exp (AST.binExp(exp1,AST.LEQ,exp2))
    | exp EQ exp (AST.binExp(exp1,AST.EQ,exp2))
    | exp GT exp (AST.binExp(exp1,AST.GT,exp2))
    | exp GEQ exp (AST.binExp(exp1,AST.GEQ,exp2))
    | exp NEQ exp (AST.binExp(exp1,AST.NEQ,exp2))
    | LPAREN exp RPAREN (AST.parExp(AST.LPAREN,exp,AST.RPAREN))
    | NEGATE exp (AST.negExp(AST.NEGATE,exp))
    | NOT exp (AST.notExp(AST.NOT,exp))
    | NUM (AST.nExp(NUM))
    | VOLT (AST.bExp(VOLT))
    | ID (AST.varExp(ID1))
var: ID (AST.symbol(ID))