include string-dict
include file("data.arr")

provide:
    evaluate
end

fun evaluate(elem :: Instructions, env :: StringDict<Instructions>) -> Any:
    doc: ```evaluates the passed element, expression or statement,
            taking into account the passed environment```
    cases (Instructions) elem:
        # Expressions (returns the other expressions)
        | numI(n) => elem
        | boolI(n) => elem
        | multI(left, right) => numI(evaluate(left, env).n * evaluate(right, env).n)
        | plusI(left, right) => numI(evaluate(left, env).n + evaluate(right, env).n)
        | lessThanI(left, right) => boolI(evaluate(left, env).n < evaluate(right, env).n)
        | variableI(name) => numI(env.get-value(name))

        # Statements (returns a changed, new environment)
        | assignI(name, expr) => env.set(name, evaluate(expr, env).n)
        | doNothingI() => env
        | ifI(cond, cons, alt) =>
            ask:
                | evaluate(cond, env) == boolI(true) then: evaluate(cons, env)
                | otherwise: evaluate(alt, env)
            end
        | sequenceI(first, second) => evaluate(second, evaluate(first, env))
        | whileI(cond, body) =>
            ask:
                | evaluate(cond, env) == boolI(true) then: evaluate(whileI(cond, body), evaluate(body, env))
                | otherwise: env
            end
    end
    where:
    evaluate(numI(5), [string-dict:]) is numI(5)
    evaluate(boolI(true), [string-dict:]) is boolI(true)

    evaluate(plusI(multI(numI(1), numI(2)), multI(numI(3), numI(4))), [string-dict:]) is numI(14)

    evaluate(variableI("x"), [string-dict: "x", 4]) is numI(4)

    evaluate(lessThanI(plusI(variableI("x"), numI(2)), variableI("y")), [string-dict: "x", 2, "y", 5])
	is boolI(true)

    evaluate(assignI("x", numI(5)), [string-dict:]) is [string-dict: "x", 5]

    evaluate(assignI("z", lessThanI(plusI(variableI("x"), numI(2)), variableI("y"))),
             [string-dict: "x", 2, "y", 5])
         is [string-dict: "x", 2, "y", 5, "z", true]

    evaluate(assignI("x", plusI(multI(numI(1), numI(2)), multI(numI(3), numI(4)))),
             [string-dict:])
         is [string-dict: "x", 14]

    evaluate(ifI(lessThanI(variableI("x"), numI(1)), # cond
                 assignI("x", numI(3)), # consequence
                 assignI("x", numI(4))), # alternative
             [string-dict: "x", 5])
         is [string-dict: "x", 4]


    seq1 = assignI("x", numI(5))
    seq2 = assignI("x", plusI(variableI("x"), plusI(numI(2), numI(2))))

    evaluate(sequenceI(seq1, seq2), [string-dict:])
        is [string-dict: "x", 9]

    evaluate(whileI(lessThanI(variableI("x"), numI(5)),
                    assignI("x", multI(variableI("x"), numI(3)))),
             [string-dict: "x", 1])
        is [string-dict: "x", 9]
end

