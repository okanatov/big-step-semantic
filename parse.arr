import s-exp as S
import lists as L

include string-dict

include file("data.arr")
include file("evaluation.arr")

fun parse(s :: S.S-Exp) -> Instructions:
    doc: "simple parser based on s-expr"
    cases (S.S-Exp) s:
        | s-num(n) => numI(n)
        | s-list(shadow s) =>
            cases (List) s:
                | empty => raise("parse: unexpected empty list")
                | link(op, args) =>
                    argL = L.get(args, 0)
                    argR = L.get(args, 1)
                    if op.s == "+":
                        plusI(parse(argL), parse(argR))
                    else if op.s == "*":
                        multI(parse(argL), parse(argR))
                    else if op.s == "<":
                        lessThanI(parse(argL), parse(argR))
                    else if op.s == "=":
                        assignI(argL.s, parse(argR))
                    else if op.s == "if":
                        argAlt = L.get(args, 2)
                        ifI(parse(argL), parse(argR), parse(argAlt))
                    end
            end
        | s-sym(shadow s) => variableI(s)
        | else =>
            raise("parse: not number, symbol or list")
    end
    where:
    parse(S.read-s-exp("(+ 1 2)")) is plusI(numI(1), numI(2))
    parse(S.read-s-exp("(< 1 2)")) is lessThanI(numI(1), numI(2))
    parse(S.read-s-exp("(< (+ 1 2) 2)")) is lessThanI((plusI(numI(1), numI(2))), numI(2))
    parse(S.read-s-exp("(= x 2)")) is assignI("x", numI(2))

    parse(S.read-s-exp("(= x (+ (* 1 2) (* 3 4)))"))
        is assignI("x", plusI(multI(numI(1), numI(2)), multI(numI(3), numI(4))))

    parse(S.read-s-exp("x")) is variableI("x")
    parse(S.read-s-exp("(< x 2)")) is lessThanI(variableI("x"), numI(2))

    parse(S.read-s-exp("(if (< 1 2) (= x 2) (= x 3))"))
        is ifI(lessThanI(numI(1), numI(2)),
               assignI("x", numI(2)),
               assignI("x", numI(3)))
end

check:
    expr :: String = "(= x 2)"
    parsed :: Instructions = parse(S.read-s-exp(expr))

    res :: Any = evaluate(parsed, [string-dict:])
    res is [string-dict: "x", 2]
end

