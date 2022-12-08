include string-dict

data Elems:
	# Expressions
	| num(value)
	| bool(value)
	| multiply(left, right)
	| add(left, right)
	| lessthan(left, right)
	| variable(name)

	# Statements
	| Assign(name, expr)
	| Donothing()
	| If(cond, cons, alt)
end

fun evaluate(elem :: Elems, env :: StringDict<Elems>) -> Any:
	cases (Elems) elem:
		# Expressions
		| num(n) => elem
		| bool(n) => elem
		| multiply(left, right) => num(evaluate(left, env).value * evaluate(right, env).value)
		| add(left, right) => num(evaluate(left, env).value + evaluate(right, env).value)
		| lessthan(left, right) => bool(evaluate(left, env).value < evaluate(right, env).value)
		| variable(name) => num(env.get-value(name))

		# Statements
		| Assign(name, expr) => env.set(name, evaluate(expr, env).value)
		| Donothing() => env
		| If(cond, cons, alt) => ask:
		                           | evaluate(cond, env) == bool(true) then: evaluate(cons, env)
					   | otherwise: evaluate(alt, env)
				         end
	end
where:
	evaluate(num(5), [string-dict:]).value is 5
	evaluate(bool(true), [string-dict:]).value is true

	evaluate(add(multiply(num(1),
	                      num(2)),
		     multiply(num(3),
		              num(4))),
		 [string-dict:]
		).value is 14

	evaluate(variable("x"), [string-dict: "x", 4]).value is 4

	evaluate(lessthan(add(variable("x"), num(2)),
	                  variable("y")),
		 [string-dict: "x", 2, "y", 5]
		).value is true

	evaluate(Assign("x", num(5)), [string-dict:]) is [string-dict: "x", 5]

	evaluate(Assign("x", add(multiply(num(1), num(2)),
                                 multiply(num(3), num(4)))),
		 [string-dict:]
	        ) is [string-dict: "x", 14]

	evaluate(Assign("z", lessthan(add(variable("x"), num(2)),
			              variable("y"))),
                 [string-dict: "x", 2, "y", 5]
	        ) is [string-dict: "x", 2, "y", 5, "z", true]

	evaluate(If(lessthan(variable("x"), num(1)),
	            Assign("x", num(3)),
		    Assign("x", num(4))),
		 [string-dict: "x", 5]
		) is [string-dict: "x", 4]
end
