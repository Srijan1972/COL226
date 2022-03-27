structure AST = 
struct
    type ID = string
    datatype varType = INT | BOOL
    and comseq = COMLIST of command list
    and command = SET of string * exp | READ of string | WRITE of exp | ITE of exp * command list * command list | WH of exp * command list
    and exp = nExp of int | bExp of bool | binExp of exp * binOp * exp | unExp of unOp * exp | varExp of string | parExp of lparen * exp * rparen
    and binOp = PLUS | MINUS | TIMES | DIV | MOD | AND | OR | LT | LEQ | EQ | GT | GEQ | NEQ
    and unOp = NOT | NEGATE
    and lparen = LPAREN
    and rparen = RPAREN
    and value = Intv of int | Boolv of bool

    val symbolTable:(string,(varType * int)) HashTable.hash_table=HashTable.mkTable(HashString.hashString,op=)(128, Fail "Undeclared Variable");
    val mem_idx=ref 0;
    fun pushtoTable([],ty:varType)=()
    |pushtoTable(x::xs,ty:varType)=(HashTable.insert symbolTable (x,(ty,!mem_idx)); mem_idx:=(!mem_idx)+1; pushtoTable(xs,ty))
end