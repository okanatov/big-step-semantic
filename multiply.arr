include file("evaluation.arr")
include file("number.arr")

provide:
	evaluate_multiply,
	multiply,
	is-multiply,
	type *
end

data Multiply: multiply(left, right) end

fun evaluate_multiply(value :: Multiply) -> Num:
	num(evaluate(typeof(value.left), value.left).value *
   	    evaluate(typeof(value.right), value.right).value)
where:
	evaluate<Multiply>(evaluate_multiply, multiply(num(5), num(6))) is num(30) 
	evaluate<Multiply>(evaluate_multiply, multiply(multiply(num(5), num(6)), num(9))) is num(270) 
	evaluate(typeof(multiply(num(5), num(6))), multiply(num(5), num(6))) is num(30) 
end

fun typeof(val :: Any) -> (Any -> Any):
	cases (Any) val:
		| multiply(l, r) => evaluate_multiply
		| num(n) => evaluate_num
	end
end
