%%
%term NUM of int | VOLT of bool | NOT | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ | NEGATE | PLUS | MINUS | TIMES | DIV | MOD | LPAREN | LBRACE | RPAREN | RBRACE | COLON | SEMICOLON | CONS | ASSIGN | COMMA | PROG | VAR | INT | BOOL | READ | WRITE | IF | THEN | ELSE | ENDIF | WHILE | DO | ENDWH | EOF | ID of string
%nonterm begin of AST.command list | decseq of unit | dec of unit | vList of string list | comseq of AST.command list | com of AST.command | exp of AST.exp | varType of AST.varType
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
begin: PROG ID CONS decseq LBRACE comseq RBRACE (AST.mem_idx:=0; comseq)
decseq: () | dec decseq ()
dec: VAR vList COLON varType SEMICOLON (AST.pushtoTable(vList,varType))
vList: ID COMMA vList (ID::vList) | ID ([ID])
varType: INT (AST.INT) | BOOL (AST.BOOL)
comseq: ([]) | com comseq (com::comseq)
com: ID ASSIGN exp SEMICOLON (HashTable.lookup AST.symbolTable ID; AST.SET(ID,exp))
    | READ ID SEMICOLON (HashTable.lookup AST.symbolTable ID; AST.READ(ID))
    | WRITE exp SEMICOLON (AST.WRITE(exp))
    | IF exp THEN LBRACE comseq RBRACE ELSE LBRACE comseq RBRACE ENDIF SEMICOLON (AST.ITE(exp,comseq1,comseq2))
    | WHILE exp DO LBRACE comseq RBRACE ENDWH SEMICOLON (AST.WH(exp,comseq))
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
    | NEGATE exp (AST.unExp(AST.NEGATE,exp))
    | NOT exp (AST.unExp(AST.NOT,exp))
    | NUM (AST.nExp(NUM))
    | VOLT (AST.bExp(VOLT))
    | ID (HashTable.lookup AST.symbolTable ID; AST.varExp(ID))
