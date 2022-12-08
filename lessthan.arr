include file("evaluation.arr")
include file("add.arr")
include file("multiply.arr")
include file("boolean.arr")
include file("number.arr")

provide:
	evaluate_lessthan,
	lessthan,
	is-lessthan,
	type *
end

data LessThan: lessthan(left, right) end

fun evaluate_lessthan(value :: LessThan) -> Bool:
	bool(evaluate(typeof(value.left), value.left).value <
   	     evaluate(typeof(value.right), value.right).value)
where:
	evaluate<LessThan>(evaluate_lessthan, lessthan(num(5), num(6))) is bool(true) 
	evaluate(typeof(lessthan(num(5), num(6))), lessthan(num(5), num(6))) is bool(true)
end

fun typeof(val :: Any) -> (Any -> Any):
	cases (Any) val:
		| lessthan(l, r) => evaluate_lessthan
		| add(l, r) => evaluate_add
		| multiply(l, r) => evaluate_multiply
		| num(n) => evaluate_num
	end
end
