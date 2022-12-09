import s-exp as S
import lists as L

data ArithC:
    | numC(n :: Number)
    | plusC(l :: ArithC, r :: ArithC)
    | multC(l :: ArithC, r :: ArithC)
    | lessThanC(l :: ArithC, r :: ArithC)
    | assignC(nm :: String, e :: ArithC)
    | variableC(n :: String)
end

fun parse(s :: S.S-Exp) -> ArithC:
    cases (S.S-Exp) s:
        | s-num(n) => numC(n)
        | s-list(shadow s) =>
            cases (List) s:
                | empty => raise("parse: unexpected empty list")
                | link(op, args) =>
                    argL = L.get(args, 0)
                    argR = L.get(args, 1)
                    if op.s == "+":
                        plusC(parse(argL), parse(argR))
                    else if op.s == "*":
                        multC(parse(argL), parse(argR))
                    else if op.s == "<":
                        lessThanC(parse(argL), parse(argR))
                    else if op.s == "=":
                        assignC(argL.s, parse(argR))
                    end
            end
        | s-sym(shadow s) => variableC(s)
        | else =>
            raise("parse: not number or list")
    end
    where:
    parse(S.read-s-exp("(+ 1 2)")) is plusC(numC(1), numC(2))
    parse(S.read-s-exp("(< 1 2)")) is lessThanC(numC(1), numC(2))
    parse(S.read-s-exp("(< (+ 1 2) 2)")) is lessThanC((plusC(numC(1), numC(2))), numC(2))
    parse(S.read-s-exp("(= x 2)")) is assignC("x", numC(2))

    parse(S.read-s-exp("(= x (+ (* 1 2) (* 3 4)))"))
        is assignC("x", plusC(multC(numC(1), numC(2)), multC(numC(3), numC(4))))

    parse(S.read-s-exp("x")) is variableC("x")
    parse(S.read-s-exp("(< x 2)")) is lessThanC(variableC("x"), numC(2))
end

