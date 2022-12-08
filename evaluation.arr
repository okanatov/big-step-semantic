include string-dict

data Elems:
	| num(value)
	| bool(value)
	| multiply(left, right)
	| add(left, right)
	| lessthan(left, right)
	| variable(name)
	| assign(name, expr)
	| donothing()
end

fun evaluate(elem :: Elems, env :: StringDict<Elems>) -> Any:
	cases (Elems) elem:
		| num(n) => elem
		| bool(n) => elem
		| multiply(left, right) => num(evaluate(left, env).value * evaluate(right, env).value)
		| add(left, right) => num(evaluate(left, env).value + evaluate(right, env).value)
		| lessthan(left, right) => bool(evaluate(left, env).value < evaluate(right, env).value)
		| variable(name) => num(env.get-value(name))
		| assign(name, expr) => env.set(name, evaluate(expr, env).value)
		| donothing() => env
	end
where:
	evaluate(num(5), [string-dict:]).value is 5
	evaluate(bool(true), [string-dict:]).value is true
	evaluate(add(multiply(num(1), num(2)), multiply(num(3), num(4))), [string-dict:]).value is 14
	evaluate(variable("x"), [string-dict: "x", 4]).value is 4
	evaluate(lessthan(add(variable("x"), num(2)), variable("y")), [string-dict: "x", 2, "y", 5]).value is true

	evaluate(assign("x", num(5)), [string-dict:]) is [string-dict: "x", 5]

	evaluate(assign("x", add(multiply(num(1), num(2)),
                                 multiply(num(3), num(4)))),
		 [string-dict:]
	        ) is [string-dict: "x", 14]

	evaluate(assign("z", lessthan(add(variable("x"), num(2)),
			              variable("y"))),
                 [string-dict: "x", 2, "y", 5]
	        ) is [string-dict: "x", 2, "y", 5, "z", true]
end
