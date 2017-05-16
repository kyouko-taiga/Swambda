import Parsec


func main() {
    guard CommandLine.arguments.count >= 2 else {
        print("Usage: \(CommandLine.arguments[0]) [-e | file]")
        return
    }

    let res: Either<ParseError, Term>
    if CommandLine.arguments[1] == "-e" {
        res = Parsec.parse(expr, "", CommandLine.arguments[2].characters)
    } else {
        res = try! parse(expr, contentsOfFile: CommandLine.arguments[1])
    }

    switch res {
    case let .left(err):
        print(err)
        print("make sure to enclose applications within parenthesis")

    case var .right(t):
        var u = t.reduced()
        while(u != t) {
            print(t)
            t = u
            u = u.reduced()
        }
        print(t)
    }

}

main()
