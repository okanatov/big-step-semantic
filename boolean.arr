include file("evaluation.arr")

provide:
	*,
	type *
end

data Bool: bool(value) end

fun evaluate_bool(value :: Bool) -> Bool:
	value
where:
	evaluate<Bool>(evaluate_bool, bool(false)) is bool(false)
end
