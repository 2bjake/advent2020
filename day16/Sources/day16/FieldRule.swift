//
//  FieldRule.swift
//
//
//  Created by Jake Foster on 12/16/20.
//

import Foundation
import Regex

private extension Int {
    init?(_ source: String?) {
        guard let source = source else { return nil }
        self.init(source)
    }
}

struct FieldRule {
    let name: String
    let ranges: [ClosedRange<Int>]

    func isValid(_ value: Int) -> Bool {
        for range in ranges {
            if range.contains(value) { return true }
        }
        return false
    }
}

func buildRules(_ source: String) -> [FieldRule] {
    let fieldsRegex = try! Regex(pattern: #"(.*): (\d+)-(\d+) or (\d+)-(\d+)\n?"#)
    let matches = fieldsRegex.findAll(in: source)
    return matches.compactMap { match in
        guard let name = match.group(at: 1),
              let firstLower = Int(match.group(at: 2)),
              let firstUpper = Int(match.group(at: 3)),
              let secondLower = Int(match.group(at: 4)),
              let secondUpper = Int(match.group(at: 5)) else {
            return nil
            }
        return FieldRule(name: name, ranges: [firstLower...firstUpper, secondLower...secondUpper])
    }
}
