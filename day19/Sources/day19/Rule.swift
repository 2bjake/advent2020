//
//  Rule.swift
//
//
//  Created by Jake Foster on 12/19/20.
//

import Foundation

enum Rule {
    case base(String)
    case compound([[String]])
}

extension Rule {
    init?(_ source: String) {
        let rawRules = source.components(separatedBy: "|").map { $0.trimmingCharacters(in: .whitespaces)}
        if rawRules.count == 1 && rawRules[0].first == "\"" {
            let value = String(rawRules[0].dropFirst().first!)
            self = .base(value)
        } else {
            let clauses = rawRules.map { $0 .components(separatedBy: " ") }
            self = .compound(clauses)
        }
    }
}

func buildRules(from data: String, applyPatch: Bool) -> [String: Rule] {
    var rulesById: [String: Rule] = data.components(separatedBy: "\n").reduce(into: [:]) { result, line in
        let parts = line.components(separatedBy: ":")
        let id = parts[0]
        result[id] = Rule(parts[1])
    }

    if applyPatch {
        rulesById["8"] = Rule("42 | 42 8")
        rulesById["11"] = Rule("42 31 | 42 11 31")
    }
    return rulesById
}
