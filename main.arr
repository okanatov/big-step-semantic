include file("evaluation.arr")
include file("add.arr")
include file("multiply.arr")
include file("number.arr")
include file("lessthan.arr")
include file("boolean.arr")

check:
	var expr = num(5)
	evaluate(typeof(expr), expr).value is 5

	expr := add(multiply(num(1), num(2)), multiply(num(3), num(4)))
	evaluate(typeof(expr), expr).value is 14

	expr := lessthan(add(num(1), num(2)), num(5))
	evaluate(typeof(expr), expr).value is true
end

fun typeof(val :: Any) -> (Any -> Any):
	cases (Any) val:
		| lessthan(l, r) => evaluate_lessthan
		| add(l, r) => evaluate_add
		| multiply(l, r) => evaluate_multiply
		| num(n) => evaluate_num
		| bool(n) => evaluate_bool
	end
end

