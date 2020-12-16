//
//  TicketValidator.swift
//
//
//  Created by Jake Foster on 12/16/20.
//

struct TicketValidator {
    let rules: [FieldRule]

    func findInvalidFields(in ticket: [Int]) -> [Int] {
        ticket.filter { value in
            for rule in rules {
                if rule.isValid(value) {
                    return false
                }
            }
            return true
        }
    }

    func isValid(_ ticket: [Int]) -> Bool {
        findInvalidFields(in: ticket).isEmpty
    }

    // takes a list of values and returns rules where all values are valid
    func findMatchingRules(for values: [Int]) -> [FieldRule] {
        rules.filter { rule in
            values.allSatisfy { value in
                rule.isValid(value)
            }
        }
    }
}

extension TicketValidator {
    init(_ source: String) {
        rules = buildRules(from: source)
    }
}
