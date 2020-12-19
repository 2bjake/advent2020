//
//  Validator.swift
//
//
//  Created by Jake Foster on 12/19/20.
//

struct Validator {
    let rulesById: [String: Rule]

    private func findPrefixLengthMatches<S: StringProtocol>(of string: S, forClause clause: ArraySlice<String>) -> Set<Int> {
        guard let firstId = clause.first else { return [0] }

        var result = Set<Int>()

        let firstLengths = findPrefixLengthMatches(of: string, forRuleId: firstId)
        for firstLength in firstLengths {
            let restLengths = findPrefixLengthMatches(of: string.dropFirst(firstLength), forClause: clause.dropFirst())
            for restLength in restLengths {
                result.insert(firstLength + restLength)
            }
        }
        return result
    }

    private func findPrefixLengthMatches<S: StringProtocol> (of string: S, forRuleId ruleId: String) -> Set<Int> {
        guard let rule = rulesById[ruleId] else { fatalError("no rule found") }
        switch rule {
            case .base(let value):
                return string.hasPrefix(value) ? [value.count] : []
            case .compound(let clauses):
                return clauses.reduce(into: []) { set, clause in
                    set.formUnion(findPrefixLengthMatches(of: string, forClause: clause[...]))
                }
        }
    }

    func isValidMessage<S: StringProtocol>(_ message: S) -> Bool {
        let matchLengths = findPrefixLengthMatches(of: message, forRuleId: "0")
        return matchLengths.contains(message.count)
    }
}
