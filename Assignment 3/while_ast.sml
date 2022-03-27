structure AST = 
struct
type ID = string

datatype progop = PROG of ID * BLK
and BLK = BLK1 of decseq * comseq | BLK2 of comseq
and decseq =  DEC1 of dec * decseq | DEC2 of dec
and vdec = varde1 of var * vdec | varde2 of var
and dec =  decl of vdec * varType
and var = symbol of string
and varType = INT | BOOL
and comseq = temp of tempcom | empty
and tempcom = com1 of command * tempcom | com2 of command
and command = SET of string * exp | READ of string | WRITE of exp | ITE of exp * comseq * comseq | WH of exp * comseq
and exp = nExp of int | bExp of bool | binExp of exp * binOp * exp | notExp of not * exp | negExp of negate * exp | varExp of string | parExp of lparen * exp * rparen | Exp of exp
and binOp = PLUS | MINUS | TIMES | DIV | MOD | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ
and not = NOT
and negate = NEGATE
and lparen = LPAREN
and rparen = RPAREN
end