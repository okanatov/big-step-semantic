provide:
	*,
	type *
end

data Num             : num(value) end
data Bool            : bool(value) end
data Multiply        : multiply(left, right) end
data Divide          : divide(left, right) end
data Add             : add(left, right) end
data Substract       : substract(left, right) end
data LessThan        : lessthan(left, right) end
data LessThanOrEqual : lessthanorequal(left, right) end
data MoreThan        : morethan(left, right) end
data MoreThanOrEqual : morethanorequal(left, right) end
data Equal           : equal(left, right) end
data NotEqual        : notequal(left, right) end

fun evaluate<T>(elem :: T) -> Any:
	cases (T) elem:
		| num(n) => elem
		| bool(n) => elem
		| multiply(left, right) => num(evaluate(left).value * evaluate(right).value)
		| divide(left, right) => num(evaluate(left).value / evaluate(right).value)
		| add(left, right) => num(evaluate(left).value + evaluate(right).value)
		| substract(left, right) => num(evaluate(left).value - evaluate(right).value)
		| lessthan(left, right) => bool(evaluate(left).value < evaluate(right).value)
		| lessthanorequal(left, right) => bool(evaluate(lessthan(left, right)).value
			                               or
						       evaluate(equal(left, right)).value)

		| morethan(left, right) => bool(evaluate(left).value > evaluate(right).value)
		| morethanorequal(left, right) => bool(evaluate(morethan(left, right)).value
			                               or
						       evaluate(equal(left, right)).value)

		| equal(left, right) => bool(evaluate(left).value == evaluate(right).value)
		| notequal(left, right) => bool(not(evaluate(equal(left, right)).value))
	end
where:
	evaluate<Number>(num(5)).value is 5
	evaluate(bool(true)).value is true
	evaluate(equal(num(5), num(5))).value is true
	evaluate(notequal(num(5), num(5))).value is false
end
