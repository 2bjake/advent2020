import Foundation
import Regex

let validator = TicketValidator(fieldData)

let tickets = allTicketData.split(separator: "\n").map {
    $0.components(separatedBy: ",").compactMap(Int.init)
}

func partOne() {
    let errorRate = tickets.flatMap {
        validator.findInvalidFields(in: $0)
    }.reduce(0, +)

    print("Answer to part one: \(errorRate)") // 20091
}
partOne()

func partTwo() {
    let validTickets = tickets.filter { validator.isValid($0) }

    var matchingRulesByIndex: [Int: Set<String>] = validTickets.buildColumns().enumerated().reduce(into: [:]) { result, value in
        let matchingRules = validator.findMatchingRules(for: value.element)
        result[value.offset] = Set(matchingRules.map(\.name))
    }

    var departureFieldIndicies = [Int]()

    while departureFieldIndicies.count < 6 {
        let singleRuleEntry = matchingRulesByIndex.first { $0.value.count == 1 }!
        let fieldName = singleRuleEntry.value.first!

        if fieldName.contains("departure") {
            departureFieldIndicies.append(singleRuleEntry.key)
        }
        matchingRulesByIndex[singleRuleEntry.key] = nil

        for idx in matchingRulesByIndex.keys {
            matchingRulesByIndex[idx]?.remove(fieldName)
        }
    }

    let myTicketFields = myTicketData.components(separatedBy: ",").compactMap(Int.init)
    let product = departureFieldIndicies.map { myTicketFields[$0] }.reduce(1, *)
    print("answer to part two: \(product)") // 2325343130651
}
partTwo()
