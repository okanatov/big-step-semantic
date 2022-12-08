include file("evaluation.arr")
include file("multiply.arr")
include file("number.arr")

provide:
	evaluate_add,
	add,
	is-add,
	type *
end

data Add: add(left, right) end

fun evaluate_add(value :: Add) -> Num:
	num(evaluate(typeof(value.left), value.left).value +
   	    evaluate(typeof(value.right), value.right).value)
where:
	evaluate<Add>(evaluate_add, add(num(5), num(6))) is num(11) 
	evaluate<Add>(evaluate_add, add(add(num(5), num(6)), num(9))) is num(20) 
	evaluate(typeof(add(num(5), num(6))), add(num(5), num(6))) is num(11) 
end

fun typeof(val :: Any) -> (Any -> Any):
	cases (Any) val:
		| add(l, r) => evaluate_add
		| multiply(l, r) => evaluate_multiply
		| num(n) => evaluate_num
	end
end
