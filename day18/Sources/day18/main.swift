import Foundation

let tokens = input.split(separator: "\n").map { line in
    line.compactMap { $0 == " " ? nil : $0 }
}

print(tokens.map { Expr.build($0).eval() }.reduce(0, +))
