include file("evaluation.arr")

provide:
	*,
	type *
end

data Num: num(value) end

fun evaluate_num(value :: Num) -> Num:
	value
where:
	evaluate<Num>(evaluate_num, num(5)) is num(5)
end
