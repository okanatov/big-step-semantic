provide:
    *,
    type *
end

data Instructions:
    | numI(n :: Number)
    | boolI(n :: Boolean)
    | plusI(l :: Instructions, r :: Instructions)
    | multI(l :: Instructions, r :: Instructions)
    | lessThanI(l :: Instructions, r :: Instructions)
    | assignI(n :: String, e :: Instructions)
    | variableI(n :: String)
    | doNothingI()
    | ifI(cond :: Instructions, cons :: Instructions, alt :: Instructions)
    | sequenceI(first :: Instructions, second :: Instructions)
    | whileI(cond :: Instructions, body :: Instructions)
end

