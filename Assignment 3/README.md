# Abstract Syntax Tree for the WHILE Language

## Context Free Grammar

- **Alphabet** - The standard ASCII character  
- **Terminals** - NUM of int | VOLT of bool | NOT | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ | NEGATE | PLUS | MINUS | TIMES | DIV | MOD | LPAREN | LBRACE | RPAREN | RBRACE | COLON | SEMICOLON | CONS | ASSIGN | COMMA | PROG | VAR | INT | BOOL | READ | WRITE | IF | THEN | ELSE | ENDIF | WHILE | DO | ENDWH | EOF | ID of string
- **Non-terminals** - begin | block | decseq | dec | varType | vList of | comseq | tempcom | com | exp | var  
- **Production Rules** -
**begin**: PROG ID CONS **block**  
**block**: **decseq** **comseq**  
| **comseq**  
**decseq**: **dec**  
| **decseq** **dec**  
**dec**: VAR **vList** COLON **varType** SEMICOLON  
**varType**: INT  
| BOOL  
**vList**: **var** COMMA **vList**  
| **var**  
**comseq**: LBRACE **tempcom** RBRACE  
| LBRACE RBRACE  
**tempcom**: **tempcom** **com**  
| **com**  
**com**: ID ASSIGN **exp** SEMICOLON  
| READ ID SEMICOLON  
| WRITE **exp** SEMICOLON  
| IF **exp** THEN **comseq** ELSE **comseq** ENDIF SEMICOLON  
| WHILE **exp** DO **comseq** ENDWH SEMICOLON  
**exp**: **exp** PLUS **exp**  
| **exp** TIMES **exp**  
| **exp** DIV **exp**  
| **exp** MOD **exp**  
| **exp** AND **exp**  
| **exp** OR **exp**  
| **exp** LT **exp**  
| **exp** LEQ **exp**  
| **exp** EQ **exp**  
| **exp** GT **exp**  
| **exp** GEQ **exp**  
| **exp** NEQ **exp**  
| LPAREN **exp** RPAREN  
| NEGATE **exp**  
| NOT **exp**  
| NUM  
| VOLT  
| ID  
**var**: ID

## AST Datatype Definition

**structure** AST =  
**struct**  
**type** ID = string  
**datatype** progop = PROG of ID * BLK  
**and** BLK = BLK1 of decseq * comseq | BLK2 of comseq  
**and** decseq =  DEC1 of dec * decseq | DEC2 of dec  
**and** vdec = varde1 of var * vdec | varde2 of var  
**and** dec =  decl of vdec * varType  
**and** var = symbol of string  
**and** varType = INT | BOOL  
**and** comseq = temp of tempcom | empty  
**and** tempcom = com1 of command * tempcom | com2 of command  
**and** command = SET of string * exp | READ of string | WRITE of exp | ITE of exp * comseq * comseq | WH of exp * comseq  
**and** exp = nExp of int | bExp of bool | binExp of exp * binOp * exp | notExp of not * exp | negExp of negate * exp | varExp of string | parExp of lparen * exp * rparen | Exp of exp  
**and** binOp = PLUS | MINUS | TIMES | DIV | MOD | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ  
**and** not = NOT  
**and** negate = NEGATE  
**and** lparen = LPAREN  
**and** rparen = RPAREN  
end  

## Syntax Directed Translation

- **Alphabet** - The standard ASCII character  
- **Terminals** - NUM of int | VOLT of bool | NOT | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ | NEGATE | PLUS | MINUS | TIMES | DIV | MOD | LPAREN | LBRACE | RPAREN | RBRACE | COLON | SEMICOLON | CONS | ASSIGN | COMMA | PROG | VAR | INT | BOOL | READ | WRITE | IF | THEN | ELSE | ENDIF | WHILE | DO | ENDWH | EOF | ID of string
- **Non-terminals** - begin | block | decseq | dec | varType | vList of | comseq | tempcom | com | exp | var  
- **Production Rules** -
**begin**: PROG ID CONS **block**  
**block**: **decseq** **comseq**  
| **comseq**  
**decseq**: **dec**  
| **decseq** **dec**  
**dec**: VAR **vList** COLON **varType** SEMICOLON  
**varType**: INT  
| BOOL  
**vList**: **var** COMMA **vList**  
| **var**  
**comseq**: LBRACE **tempcom** RBRACE  
| LBRACE RBRACE  
**tempcom**: **tempcom** **com**  
| **com**  
**com**: ID ASSIGN **exp** SEMICOLON  
| READ ID SEMICOLON  
| WRITE **exp** SEMICOLON  
| IF **exp** THEN **comseq** ELSE **comseq** ENDIF SEMICOLON  
| WHILE **exp** DO **comseq** ENDWH SEMICOLON  
**exp**: **exp** PLUS **exp**  
| **exp** TIMES **exp**  
| **exp** DIV **exp**  
| **exp** MOD **exp**  
| **exp** AND **exp**  
| **exp** OR **exp**  
| **exp** LT **exp**  
| **exp** LEQ **exp**  
| **exp** EQ **exp**  
| **exp** GT **exp**  
| **exp** GEQ **exp**  
| **exp** NEQ **exp**  
| LPAREN **exp** RPAREN  
| NEGATE **exp**  
| NOT **exp**  
| NUM  
| VOLT  
| ID  
**var**: ID

## Design/Implementation Decisions

- Some names of non-terminals do not match the names given in the pdf.
- Type checking and variable declaration have not been done at this stage => the file has only been parsed.

## Acknowldegements

- The glue code in `loader.sml` has been taken from [here](https://www.smlnj.org/doc/ML-Yacc/mlyacc007.html) (From the ml-yacc documentation)

## Running Instructions

In the terminal: 

```bash
make
```

Then in the sml repl that opens:

```sml
parseIt "filename";
```