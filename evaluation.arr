include string-dict

data Elems:
    # Expressions
    | Num(value)
    | Bool(value)
    | Multiply(left, right)
    | Add(left, right)
    | Lessthan(left, right)
    | Variable(name)

    # Statements
    | Assign(name, expr)
    | Donothing()
    | If(cond, cons, alt)
end

fun evaluate(elem :: Elems, env :: StringDict<Elems>) -> Any:
    doc: "evaluates the passed element, expression or statement, taking into account the passed environment"
    cases (Elems) elem:
        # Expressions
        | Num(n) => elem
        | Bool(n) => elem
        | Multiply(left, right) => Num(evaluate(left, env).value * evaluate(right, env).value)
        | Add(left, right) => Num(evaluate(left, env).value + evaluate(right, env).value)
        | Lessthan(left, right) => Bool(evaluate(left, env).value < evaluate(right, env).value)
        | Variable(name) => Num(env.get-value(name))

        # Statements
        | Assign(name, expr) => env.set(name, evaluate(expr, env).value)
        | Donothing() => env
        | If(cond, cons, alt) =>
            ask:
                | evaluate(cond, env) == Bool(true) then: evaluate(cons, env)
                | otherwise: evaluate(alt, env)
            end
    end
    where:
    evaluate(Num(5), [string-dict:]).value is 5
    evaluate(Bool(true), [string-dict:]).value is true

    evaluate(Add(Multiply(Num(1), Num(2)),
                 Multiply(Num(3), Num(4))), [string-dict:]
            ).value is 14

    evaluate(Variable("x"), [string-dict: "x", 4]).value is 4

    evaluate(Lessthan(Add(Variable("x"), Num(2)),
                      Variable("y")), [string-dict: "x", 2, "y", 5]
            ).value is true

    evaluate(Assign("x", Num(5)), [string-dict:]) is [string-dict: "x", 5]

    evaluate(Assign("x", Add(Multiply(Num(1), Num(2)),
                              Multiply(Num(3), Num(4)))),
             [string-dict:]) is [string-dict: "x", 14]

    evaluate(Assign("z", Lessthan(Add(Variable("x"), Num(2)),
                                  Variable("y"))),
             [string-dict: "x", 2, "y", 5]) is [string-dict: "x", 2, "y", 5, "z", true]

    evaluate(If(Lessthan(Variable("x"), Num(1)),
                Assign("x", Num(3)),
                Assign("x", Num(4))),
             [string-dict: "x", 5]) is [string-dict: "x", 4]
    end
