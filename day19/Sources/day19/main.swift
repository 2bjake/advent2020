import Foundation


let rules: [Rule] = ruleData.components(separatedBy: "\n").compactMap(Rule.init)
let rulesById: [String: Rule] = rules.reduce(into: [:]) { result, value in
    result[value.id] = value
}

func findPrefixLengthMatches<S: StringProtocol>(of string: S, forClause clause: Pair<String>) -> Set<Int> {
    let firstPrefixLengths = findPrefixLengthMatches(of: string, forRuleId: clause.first)
    guard !firstPrefixLengths.isEmpty else { return [] }
    guard let secondId = clause.second else { return firstPrefixLengths }

    var result = Set<Int>()
    for firstLength in firstPrefixLengths {
        let secondPrefixLengths = findPrefixLengthMatches(of: string.dropFirst(firstLength), forRuleId: secondId)
        for secondLength in secondPrefixLengths {
            result.insert(firstLength + secondLength)
        }

    }
    return result
}

func findPrefixLengthMatches<S: StringProtocol> (of string: S, forRuleId ruleId: String) -> Set<Int> {
    guard let rule = rulesById[ruleId] else { fatalError("no rule found") }
    switch rule.value {
        case .base(let value):
            return string.hasPrefix(value) ? [value.count] : []
        case .compound(let clauses):
            return Set(clauses.flatMap {
                findPrefixLengthMatches(of: string, forClause: $0)
            })
    }
}

let validMessages = messageData.split(separator: "\n").filter { message in
    findPrefixLengthMatches(of: message, forRuleId: "0").contains(message.count)
}

print("answer to part one: \(validMessages.count)")
