import Foundation

let tokens = input.split(separator: "\n").map { line in
    line.compactMap { $0 == " " ? nil : $0 }
}

func evaluate(_ tokens: [[Character]], leftToRightPrecedence: Bool) -> Int {
    let builder = Expr.Builder(leftToRightPrecedence: leftToRightPrecedence)
    return tokens.map { builder.build($0).eval() }.reduce(0, +)
}

let partOne = evaluate(tokens, leftToRightPrecedence: true)
print("answer to part one: \(partOne)") // 4491283311856

let partTwo = evaluate(tokens, leftToRightPrecedence: false)
print("answer to part two: \(partTwo)") // 68852578641904
