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

let validTickets = tickets.filter { validator.isValid($0) }

var validRulesByIndex: [Int: Set<String>] = validTickets.getColumns().enumerated().reduce(into: [:]) { result, value in
    let validRules = validator.findValidRules(values: value.element)

    result[value.offset] = Set(validRules.map(\.name))
}

var departureIndicies = [Int]()

while departureIndicies.count < 6 {
    let singleRuleEntry = validRulesByIndex.first { $0.value.count == 1 }!
    let fieldName = singleRuleEntry.value.first!
    if fieldName.contains("departure") {
        departureIndicies.append(singleRuleEntry.key)
    }
    for idx in validRulesByIndex.keys {
        validRulesByIndex[idx]?.remove(fieldName)
    }
}

let myTicketFields = myTicketData.components(separatedBy: ",").compactMap(Int.init)
print(departureIndicies.map { myTicketFields[$0] }.reduce(1, *))
