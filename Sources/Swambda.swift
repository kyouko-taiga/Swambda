import Parsec


indirect enum Term {

    case variable(String)
    case application(Term, Term)
    case abstraction(String, Term)

    func reduced() -> Term {
        switch self {
        case let .application(t, u):
            if case let .abstraction(v, e) = t {
                return e.substituting(v, for: u)
            }

            let t1 = t.reduced()
            return t1 == t
                ? .application(t, u.reduced())
                : .application(t1, u)

        case let .abstraction(v, e):
            return .abstraction(v, e.reduced())

        case .variable(_):
            return self
        }
    }

    func substituting(_ variable: String, for term: Term) -> Term {
        switch self {
        case let .variable(v):
            return v == variable
                ? term
                : self

        case let .application(t, u):
            return .application(
                t.substituting(variable, for: term),
                u.substituting(variable, for: term))

        case let .abstraction(v, e):
            return .abstraction(v, e.substituting(variable, for: term))
        }
    }

}

extension Term: Equatable {

    static func ==(lhs: Term, rhs: Term) -> Bool {
        switch (lhs, rhs) {
        case let (.variable(v0), .variable(v1)):
            return v0 == v1
        case let (.application(t0, u0), .application(t1, u1)):
            return (t0 == t1) && (u0 == u1)
        case let (.abstraction(v0, e0), .abstraction(v1, e1)):
            return (v0 == v1) && (e0 == e1)
        default:
            return false
        }
    }

}

extension Term: CustomStringConvertible {

    var description: String {
        switch self {
        case .variable(let n):
            return n
        case let .application(t, u):
            return "(\(t) \(u))"
        case let .abstraction(v, e):
            return "λ\(v).\(e)"
        }
    }

}


func expr() -> StringParser<Term> {
    return (spaces >>> term <<< eof)()
}

func term() -> StringParser<Term> {
    return (abstraction <|> application <|> variable <|> enclosed <?> "term")()
}

func variable() -> StringParser<Term> {
    return (identifier >>- { v in
        create(.variable(v))
    } <?> "variable")()
}

func application() -> StringParser<Term> {
    return (between(leftPar, rightPar, sepBy1(term, spaces)) >>- { ts in
        return create(ts.dropFirst().reduce(ts[0], { .application($0, $1) }))
    } <?> "application")()
}

func abstraction() -> StringParser<Term> {
    return (oneOf("λ/") >>> identifier >>- { v in
        char(".") >>> term >>- { e in
            return create(.abstraction(v, e))
        }
    } <?> "abstraction")()
}

func identifier() -> StringParser<String> {
    return (letter >>- { head in
        many(letter <|> digit) >>- { tail in
            let s = [head] + tail
            return create(String(s))
        }
    } <?> "variable identifier")()
}

func enclosed() -> StringParser<Term> {
    return between(leftPar, rightPar, term)()
}

func leftPar() -> StringParser<Character> {
    return (char("(") <<< spaces <?> "open parenthesis")()
}

func rightPar () -> StringParser<Character> {
    return (char(")") <<< spaces <?> "close parenthesis")()
}
