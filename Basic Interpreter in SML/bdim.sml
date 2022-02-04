val mem=Array.array(64,0);

fun quadFromString(s)=(*Format string to tuple*)
    let val s'=String.substring(s, 1, String.size(s)-1)
    in
        let val [a,b,c,d]=List.mapPartial Int.fromString (String.tokens (fn c => c = #",") s')
        in (a,b,c,d)
        end
    end;

fun readlist (file : string) = (*Convert file to list of strings*)
    let val ins = TextIO.openIn file 
        fun read ins = 
            case TextIO.inputLine ins of 
                SOME line => line :: read ins
                | NONE      => [] 
    in 
        read ins before TextIO.closeIn ins 
    end;

fun makelist([],l)=l
|makelist(x::xs,l)=makelist(xs,quadFromString(x)::l);

fun makeCode(file)= (*Make instruction vector*)
    let val stuff=readlist(file)
        val l=List.rev(makelist(stuff,[]))
    in Vector.fromList(l)
    end;

fun exec(code,idx)=
    let val tup=Vector.sub(code,idx)
    in
        let val (a,b,c,d)=tup
        in
            if a=0 then ()
            else if a=1 then
            let val it=print("input: ")
                val inp=valOf(Int.fromString(valOf(TextIO.inputLine TextIO.stdIn)))
            in
                let val it=Array.update(mem,d,inp)
                in
                    exec(code,idx+1)
                end
            end  handle Subscript => print("Invalid Index\n")
            else if a=2 then 
            let val wild=Array.update(mem,d,Array.sub(mem,b))
            in
                exec(code,idx+1)
            end handle Subscript => print("Invalid Index\n")
            else if a=3 then
            let val inp=Array.sub(mem,b)
            in
                if inp=0 orelse inp=1 then
                let val wild=Array.update(mem,d,1-inp)
                in
                    exec(code,idx+1)
                end
                else print("Invalid Boolean\n")
            end handle Subscript => print("Invalid Index\n")
            else if a=4 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                if (inp1=0 orelse inp1=1) andalso (inp2=0 orelse inp2=1) then
                let val wild=Array.update(mem,d,Int.min(1,inp1+inp2))
                in
                    exec(code,idx+1)
                end
                else print("Invalid Boolean\n")
            end handle Subscript => print("Invalid Index\n")
            else if a=5 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                if (inp1=0 orelse inp1=1) andalso (inp2=0 orelse inp2=1) then
                let val wild=Array.update(mem,d,inp1*inp2)
                in
                    exec(code,idx+1)
                end
                else print("Invalid Boolean\n")
            end handle Subscript => print("Invalid Index\n")
            else if a=6 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                let val wild=Array.update(mem,d,inp1+inp2)
                in
                    exec(code,idx+1)
                end
            end handle Subscript => print("Invalid Index\n")
            else if a=7 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                let val wild=Array.update(mem,d,inp1-inp2)
                in
                    exec(code,idx+1)
                end
            end handle Subscript => print("Invalid Index\n")
            else if a=8 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                let val wild=Array.update(mem,d,inp1*inp2)
                in
                    exec(code,idx+1)
                end
            end handle Subscript => print("Invalid Index\n")
            else if a=9 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                let val wild=Array.update(mem,d,inp1 div inp2)
                in
                    exec(code,idx+1)
                end
            end handle Subscript => print("Invalid Index\n")
                | Div => print("Division by 0 not allowed\n")
            else if a=10 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                let val wild=Array.update(mem,d,inp1 mod inp2)
                in
                    exec(code,idx+1)
                end
            end handle Subscript => print("Invalid Index\n")
                | Div => print("Division by 0 not allowed\n")
            else if a=11 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                let val wild=Array.update(mem,d,if inp1=inp2 then 1 else 0)
                in
                    exec(code,idx+1)
                end
            end handle Subscript => print("Invalid Index\n")
            else if a=12 then
            let val inp1=Array.sub(mem,b)
                val inp2=Array.sub(mem,c)
            in
                let val wild=Array.update(mem,d,if inp1>inp2 then 1 else 0)
                in
                    exec(code,idx+1)
                end
            end handle Subscript => print("Invalid Index\n")
            else if a=13 then
            let val inp=Array.sub(mem,b)
            in
                if inp=1 then exec(code,d)
                else if inp=0 then exec(code,idx+1)
                else print("Invalid Boolean\n")
            end handle Subscript => print("Invalid Index\n")
            else if a=14 then exec(code,d) handle Subscript => print("Invalid Index\n")
            else if a=15 then
            let val ou=print(Int.toString(Array.sub(mem,b))^"\n")
            in
                exec(code,idx+1)
            end handle Subscript => print("Invalid Index\n")
            else if a=16 then
            let val ou=Array.update(mem,d,b)
            in
                exec(code,idx+1)
            end handle Subscript => print("Invalid Index\n")
            else print("Invalid Operand\n")
        end
    end handle Subscript => print("Invalid Index\n");

fun interpret(filename)=
    let val code=makeCode(filename)
    in
        exec(code,0)
    end handle Overflow => print("Overflow Error\n");
