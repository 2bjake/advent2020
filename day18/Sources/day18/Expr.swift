//
//  Expr.swift
//
//
//  Created by Jake Foster on 12/18/20.
//

indirect enum Expr {
    case digit(Int)
    case plus(Expr, Expr)
    case multiply(Expr, Expr)
    case parens(Expr)
}

extension Expr {
    func eval() -> Int {
        switch self {
            case .digit(let value):
                return value
            case .plus(let left, let right):
                return left.eval() + right.eval()
            case .multiply(let left, let right):
                return left.eval() * right.eval()
            case .parens(let expr):
                return expr.eval()
        }
    }
}

extension Expr {
    struct Builder {
        let leftToRightPrecedence: Bool

        private typealias ParseResult = (expr: Expr, remainingTokens: ArraySlice<Character>)

        func build(_ tokens: [Character]) -> Expr {
            return build(tokens[...])
        }

        private func build(_ tokens: ArraySlice<Character>) -> Expr {
            var remainingTokens = tokens
            var expr: Expr?
            while !remainingTokens.isEmpty {
                (expr, remainingTokens) = subBuild(remainingTokens, leftExpr: expr)
            }
            return expr!
        }

        private func getParenSlice(_ slice: ArraySlice<Character>) -> ArraySlice<Character> {
            guard slice.first == "(" else { return [] }
            var current = slice
            var parenCount = 1
            while parenCount != 0 {
                current = current.dropFirst()
                switch current.first! {
                    case "(": parenCount += 1
                    case ")": parenCount -= 1
                    default: break
                }
            }
            return slice[slice.startIndex+1..<current.startIndex]
        }

        private func subBuild(_ tokens: ArraySlice<Character>, leftExpr: Expr? = nil) -> ParseResult {
            guard let first = tokens.first else { fatalError("empty token stream") }
            switch first {
                case "+":
                    guard let leftExpr = leftExpr else { fatalError("missing left for '+'" ) }
                    let (rightExpr, remainingTokens) = subBuild(tokens.dropFirst())
                    return (.plus(leftExpr, rightExpr), remainingTokens)
                case "*":
                    guard let leftExpr = leftExpr else { fatalError("missing left for '*'" ) }
                    var (rightExpr, remainingTokens) = subBuild(tokens.dropFirst())

                    if !leftToRightPrecedence {
                        // perform lookahead for +
                        while remainingTokens.first == "+" {
                            (rightExpr, remainingTokens) = subBuild(remainingTokens, leftExpr: rightExpr)
                        }
                    }
                    return (.multiply(leftExpr, rightExpr), remainingTokens)
                case "(":
                    let parenSlice = getParenSlice(tokens)
                    let expr = build(parenSlice)
                    return (.parens(expr), tokens.dropFirst(parenSlice.count + 2))
                case ")":
                    fatalError("didn't expect to see ')'")
                default:
                    guard let value = Int(String(first)) else { fatalError("could not parse '\(first)'") }
                    return (.digit(value), tokens.dropFirst())
            }
        }
    }
}
