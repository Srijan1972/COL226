# Evaluator for the WHILE Language

## Running Instructions

In a terminal:

```bash
    make
```

Then in the sml repl that opens:

To parse:

```sml
    aslt "filename";
```

To execute:

```sml
    run "filename";
```

## Context Free Grammar of the Language

- **Alphabet** - The standard ASCII characters  
- **Terminals** - NUM of int | VOLT of bool | NOT | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ | NEGATE | PLUS | MINUS | TIMES | DIV | MOD | LPAREN | LBRACE | RPAREN | RBRACE | COLON | SEMICOLON | CONS | ASSIGN | COMMA | PROG | VAR | INT | BOOL | READ | WRITE | IF | THEN | ELSE | ENDIF | WHILE | DO | ENDWH | EOF | ID of string
- **Non-terminals** - begin | decseq | dec | varType | vList | comseq | | com | exp  
- **Production Rules** -
**begin**: PROG ID CONS **decseq** LBRACE **comseq** RBRACE  
**decseq**: $\epsilon$ | **dec** **decseq**  
**dec**: VAR **vList** COLON **varType** SEMICOLON  
**vList**: ID COMMA **vList** | ID  
**varType**: INT | BOOL  
**comseq**: $\epsilon$ | **com** **comseq**  
**com**: ID ASSIGN **exp** SEMICOLON  
| READ ID SEMICOLON  
| WRITE **exp** SEMICOLON  
| IF **exp** THEN LBRACE **comseq** RBRACE ELSE LBRACE **comseq** RBRACE ENDIF SEMICOLON  
| WHILE **exp** DO LBRACE **comseq** RBRACE ENDWH SEMICOLON  
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

## Acknowldegements

- The glue code in `parseloader.sml` has been taken from [here](https://www.smlnj.org/doc/ML-Yacc/mlyacc007.html) (From the ml-yacc documentation)