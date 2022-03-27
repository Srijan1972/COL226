use "parseloader.sml";
use "funstack.sml";

signature VMC =
sig
    type vals
    type pfixmems
  val postfix:AST.command list -> pfixmems FunStack.Stack
  val evalExp:AST.exp * int array -> AST.value
  val rules:vals FunStack.Stack * int array * pfixmems FunStack.Stack -> vals FunStack.Stack * int array * pfixmems FunStack.Stack
  val execute:string -> vals FunStack.Stack * int array * pfixmems FunStack.Stack
  val VMCString:vals FunStack.Stack * int array * pfixmems FunStack.Stack -> string * int array * string
end

structure Vmc :> VMC =
struct
open AST
open FunStack
    datatype vals = K of int | pList of command list | IB of varType | L of bool | E of exp
    and pfixmems = EX of exp | read | write | ite | wh | set | Id of string | aList of command list
    fun postfix(CL:command list):pfixmems Stack=
        if List.null(CL) then let val it:pfixmems Stack=create() in it end
        else let val a=List.hd(CL)
            in
                case a of
                    READ(s) => push(Id s,push(read,postfix(List.tl(CL))))
                    | WRITE(e) => push(EX e,push(write,postfix(List.tl(CL))))
                    | SET(s,e) => push(Id s,push(EX e,push(set,postfix(List.tl(CL)))))
                    | ITE(e,c1,c2) => push(EX e,push(aList c1,push(aList c2,push(ite,postfix(List.tl(CL))))))
                    | WH(e,c) => push(EX e,push(aList c,push(wh,postfix(List.tl(CL)))))
            end
    fun boolToInt(a)=if a then 1 else 0
    fun evalExp(e:exp,M:int array):value=
        case e of
            nExp i => Intv i
            | bExp i => Boolv i
            | binExp(e1,b,e2) => BinEval(e1,b,e2,M)
            | unExp (u,e1) => unanEval(u,e1,M)
            | parExp (LPAREN,e1,RPAREN) => evalExp(e1,M)
            | varExp i =>
                let val (A,B)=HashTable.lookup symbolTable i
                    val yt=Array.sub(M,B)
                in
                    case A of
                        INT => Intv (yt)
                        | BOOL => if yt=1 then Boolv (true) else if yt=0 then Boolv (false) else raise Fail("Invalid Boolean")
                end
    and BinEval(e1,b,e2,M):value=
        case (evalExp(e1,M),b,evalExp(e2,M)) of
            (Intv i1,PLUS,Intv i2) => Intv (i1+i2)
            | (Intv i1,MINUS,Intv i2) => Intv (i1-i2)
            | (Intv i1,TIMES,Intv i2) => Intv (i1*i2)
            | (Intv i1,DIV,Intv i2) => Intv (i1 div i2)
            | (Intv i1,MOD,Intv i2) => Intv (i1 mod i2)
            | (Boolv i1,AND,Boolv i2) => Boolv (i1 andalso i2)
            | (Boolv i1,OR,Boolv i2) => Boolv (i1 orelse i2)
            | (Intv i1,LT,Intv i2) => Boolv (i1 < i2)
            | (Intv i1,LEQ,Intv i2) => Boolv (i1 <= i2)
            | (Intv i1,EQ,Intv i2) => Boolv (i1 = i2)
            | (Intv i1,GT,Intv i2) => Boolv (i1 > i2)
            | (Intv i1,GEQ,Intv i2) => Boolv (i1 >= i2)
            | (Intv i1,NEQ,Intv i2) => Boolv (i1 <> i2)
            | (Boolv i1,LT,Boolv i2) => Boolv (boolToInt(i1) < boolToInt(i2))
            | (Boolv i1,LEQ,Boolv i2) => Boolv (boolToInt(i1) <= boolToInt(i2))
            | (Boolv i1,EQ,Boolv i2) => Boolv (boolToInt(i1) = boolToInt(i2))
            | (Boolv i1,GT,Boolv i2) => Boolv (boolToInt(i1) > boolToInt(i2))
            | (Boolv i1,GEQ,Boolv i2) => Boolv (boolToInt(i1) >= boolToInt(i2))
            | (Boolv i1,NEQ,Boolv i2) => Boolv (boolToInt(i1) <> boolToInt(i2))
            | _ => raise Fail "Invalid Type"
    and unanEval(u,e,M):value=
        case (u,evalExp(e,M)) of
        (NOT,Boolv i) => Boolv (not i)
        | (NEGATE,Intv i) => Intv (0-i)
        | _ => raise Fail "Invalid type"
    fun rules(V:vals FunStack.Stack,M,C)=
        if empty(C) then (V,M,C)
        else
            let val c=top(C)
            in
                case c of
                Id x =>
                    let val (A,B)=HashTable.lookup symbolTable x
                    in
                        rules(push(IB A,push(K B,V)),M,pop(C))
                    end
                | EX c =>
                    let val res=evalExp(c,M)
                    in
                        case res of
                        Intv i => rules(push(E c,push(K i,V)),M,pop(C))
                        |Boolv i => rules(push(E c,push(L i,V)),M,pop(C))
                    end
                | aList c => rules(push(pList c,V),M,pop(C))
                | read =>
                        let val i=top(pop(V)) val inp=valOf(Int.fromString(valOf(TextIO.inputLine TextIO.stdIn))) in
                        case (top(V),i) of
                        (IB INT,K i) => (Array.update(M,i,inp); rules(pop(pop(V)),M,pop(C)))
                        | (IB BOOL,K i) => if inp=1 orelse inp=0 then let val it1=Array.update(M,i,inp) in rules(pop(pop(V)),M,pop(C)) end else raise Fail "Invalid Boolean"
                        | _ => raise Fail "Invalid Stack"
                        end
                | write =>
                    let val j=top(pop(V)) in
                    case (j) of
                    (K i) => let val it=print(Int.toString(i)^"\n") in rules(pop(pop(V)),M,pop(C)) end
                    | (L i) => let val it=print(Int.toString(boolToInt(i))^"\n") in rules(pop(pop(V)),M,pop(C)) end
                    | _ => raise Fail "Invalid Stack"
                    end
                | set =>
                    let val j=top(pop(pop(pop(V)))) in
                    case (top(pop(V)),top(pop(pop(V))),j) of
                    (K i,IB INT,K j) => let val it=Array.update(M,j,i) in rules(pop(pop(pop(pop(V)))),M,pop(C)) end
                    | (L i,IB BOOL,K j) => let val it=Array.update(M,j,boolToInt(i)) in rules(pop(pop(pop(pop(V)))),M,pop(C)) end
                    | _ => raise Fail "Invalid Stack"
                    end
                | ite =>
                    let val k=top(V) in
                    case (k,top(pop(V)),top(pop(pop(pop(V))))) of
                    (pList c1,pList c2,L i) => if i then rules(pop(pop(pop(pop(V)))),M,pushList(postfix(c2),pop(C))) else rules(pop(pop(pop(pop(V)))),M,pushList(postfix(c1),pop(C)))
                    | _ => raise Fail "Invalid Stack"
                    end
                | wh =>
                    let val j=top(pop(V)) in
                    case (top(V),top(pop(pop(V))),j) of
                    (pList c1,L i,E j) => if i then rules(pop(pop(pop(V))),M,pushList(postfix(c1),push(EX j,push(aList c1,C)))) else rules(pop(pop(pop(V))),M,pop(C))
                    | _ => raise (Fail "Invalid Stack")
                    end
            end
    fun execute(filename)=
        let val V:vals FunStack.Stack=FunStack.create()
            val M=Array.array(128,0)
            val C=postfix(aslt(filename))
        in
            rules(V,M,C)
        end
    
    fun eString(e:exp):string=
        case e of
            nExp i => Int.toString(i)
            | bExp i => if i then "true" else "false"
            | binExp (e1,PLUS,e2) => eString(e1)^" + "^eString(e2)
            | binExp (e1,MINUS,e2) => eString(e1)^" - "^eString(e2)
            | binExp (e1,TIMES,e2) => eString(e1)^" * "^eString(e2)
            | binExp (e1,DIV,e2) => eString(e1)^" / "^eString(e2)
            | binExp (e1,MOD,e2) => eString(e1)^" % "^eString(e2)
            | binExp (e1,AND,e2) => eString(e1)^" && "^eString(e2)
            | binExp (e1,OR,e2) => eString(e1)^" || "^eString(e2)
            | binExp (e1,LT,e2) => eString(e1)^" < "^eString(e2)
            | binExp (e1,LEQ,e2) => eString(e1)^" <= "^eString(e2)
            | binExp (e1,EQ,e2) => eString(e1)^" = "^eString(e2)
            | binExp (e1,GT,e2) => eString(e1)^" > "^eString(e2)
            | binExp (e1,GEQ,e2) => eString(e1)^" >= "^eString(e2)
            | binExp (e1,NEQ,e2) => eString(e1)^" <> "^eString(e2)
            | parExp (LPAREN,e1,RPAREN) => "("^eString(e1)^")"
            | varExp i => i
            | unExp (NOT,e1) => "!"^eString(e1)
            | unExp (NEGATE,e1) => "~"^eString(e1)
    and comString(com:command):string=
        case com of
        READ(s) => "read "^s
        | WRITE(e) => "write "^eString(e)
        | SET(s,e) => "set "^s^" "^eString(e)
        | ITE(e,c1,c2) => "ite "^eString(e)^" "^lString(c1)^" "^lString(c2)
        | WH(e,c) => "wh "^eString(e)^" "^lString(c)
    and lString(l:command list):string=
        let val temp=List.map comString l
            fun conc(s1,s2)=s1^", "^s2
            val f=List.foldr conc "" temp
        in
            "["^f^"]"
        end
    and vString(v:vals):string=
        case v of
        K i => Int.toString(i)
        | L i => if i then "true" else "false"
        | IB INT => "INT"
        | IB BOOL => "BOOL"
        | E e => eString(e)
        | pList c => lString(c)
    and cString(c:pfixmems):string=
        case c of
        read => "read"
        | write => "write"
        | ite => "ite"
        | wh => "wh"
        | set => "set"
        | Id s => s
        | aList c => lString(c)
        | EX e => eString(e)
    fun VMCString(V,M,C)=(toString vString V,M,toString cString C)
end

fun run(filename)=Vmc.VMCString(Vmc.execute(filename))