include file("evaluation.arr")

check:
	var expr = num(5)
	evaluate(expr).value is 5

	expr := add(multiply(num(1), num(2)), multiply(num(3), num(4)))
	evaluate(expr).value is 14

	expr := lessthan(add(num(1), num(2)), num(5))
	evaluate(expr).value is true

	expr := substract(add(num(1), num(2)), num(4))
	evaluate(expr).value is -1

	expr := equal(num(4), num(4))
	evaluate(expr).value is true

	expr := notequal(num(4), num(4))
	evaluate(expr).value is false

	expr := lessthanorequal(num(4), num(4))
	evaluate(expr).value is true

	expr := lessthanorequal(num(4), num(5))
	evaluate(expr).value is true
end

