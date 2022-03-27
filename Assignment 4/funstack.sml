signature STACK =
sig
    type 'a Stack
    exception EmptyStack
    exception Error of string
    val create: unit -> 'a Stack
    val push:'a * 'a Stack -> 'a Stack
    val pop:'a Stack -> 'a Stack
    val top:'a Stack -> 'a
    val empty:'a Stack -> bool
    val poptop:'a Stack -> ('a * 'a Stack) option
    val nth:'a Stack * int -> 'a
    val drop:'a Stack * int -> 'a Stack
    val depth:'a Stack -> int
    val app:('a -> unit) -> 'a Stack -> unit
    val map:('a -> 'b) -> 'a Stack -> 'b Stack
    val mapPartial:('a -> 'b option) -> 'a Stack -> 'b Stack
    val find:('a -> bool) -> 'a Stack -> 'a option
    val filter:('a -> bool) -> 'a Stack -> 'a Stack
    val foldr:('a * 'b -> 'b) -> 'b -> 'a Stack -> 'b
    val foldl:('a * 'b -> 'b) -> 'b -> 'a Stack -> 'b
    val exists:('a -> bool) -> 'a Stack -> bool
    val all:('a -> bool) -> 'a Stack -> bool
    val list2Stack:'a list -> 'a Stack
    val Stack2list:'a Stack -> 'a list
    val toString:('a -> string) -> 'a Stack -> string
    val pushList:'a Stack * 'a Stack -> 'a Stack
end

structure FunStack :> STACK =
struct
    type 'a Stack = 'a list
    exception EmptyStack
    exception Error of string
    fun create()=[]
    fun push(a,S)=a::S
    fun pop([])=raise EmptyStack
    | pop(a::tlS)=tlS
    fun top([])=raise EmptyStack
    | top(a::tlS)=a
    fun empty([])=true
    | empty(a::tlS)=false
    fun poptop([])=NONE
    | poptop(a::tlS)=SOME (a,tlS)
    fun nth(S,i)=List.nth(S,i)
    fun drop(S,i)=List.drop(S,i)
    fun depth([])=0
    | depth(a::tlS)=1+depth(tlS)
    fun app f S=List.app f S
    fun map f S=List.map f S
    fun mapPartial f S=List.mapPartial f S
    fun find f S=List.find f S
    fun filter f S=List.filter f S
    fun foldr f init S=List.foldr f init S
    fun foldl f init S=List.foldl f init S
    fun exists f S=List.exists f S
    fun all f S=List.all f S
    fun list2Stack(S)=S
    fun Stack2list(S)=S
    fun toString a2s S=
        let val L=map a2s S
            fun conc(s1,s2)=s1^" "^s2
            val temp=foldr conc "" L
        in
            "["^temp^"]"
        end
    fun pushList(L,S)=L@S
end