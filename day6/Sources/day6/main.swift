import Foundation

let entries = input.components(separatedBy: "\n\n")

// part 1
let answers = entries.map { group in
    group.split(separator: "\n").flatMap(Array.init)
}

let partOneCount = answers.map(Set.init).map(\.count).reduce(0, +)
print("The answer to part one: \(partOneCount)")

// part 2

extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
    }
}

typealias Group = (groupSize: Int, answers: [Character])

let groups: [Group] = entries.map { group in
    let lines = group.split(separator: "\n")
    return (lines.count, lines.flatMap(Array.init))
}

let partTwoCount = groups.map { groupSize, answers in
    answers.reduce(into: [:]) { result, value in
        result[value, default: 0] += 1
    }.count { $0.value == groupSize }
}.reduce(0, +)

print("The answer to part two: \(partTwoCount)")

