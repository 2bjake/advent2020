//
//  TicketValidator.swift
//
//
//  Created by Jake Foster on 12/16/20.
//

typealias Ticket = [Int]

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    func getColumn(at idx: Index) -> [Element.Element] {
        (0..<count).map { self[$0][idx] }
    }

    func getColumns() -> [[Element.Element]] {
        (0..<self[0].count).map(getColumn)
    }
}

struct TicketValidator {
    let rules: [FieldRule]

    func findInvalidFields(in ticket: Ticket) -> [Int] {
        ticket.filter { value in
            for rule in rules {
                if rule.isValid(value) {
                    return false
                }
            }
            return true
        }
    }

    func isValid(_ ticket: Ticket) -> Bool {
        findInvalidFields(in: ticket).isEmpty
    }

    func findValidRules(values: [Int]) -> [FieldRule] {
        rules.filter { rule in
            values.allSatisfy { value in
                rule.isValid(value)
            }
        }
    }
}

extension TicketValidator {
    init(_ source: String) {
        rules = buildRules(source)
    }
}
