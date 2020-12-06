import Foundation

let entries = input.components(separatedBy: "\n\n")

typealias Group = (size: Int, answers: [Character])

let groups: [Group] = entries.map {
    let lines = $0.split(separator: "\n")
    return (lines.count, lines.flatMap(Array.init))
}

// part 1
let partOneCount = groups.map { Set($0.answers).count }.reduce(0, +)
print("The answer to part one: \(partOneCount)") // 6437

// part 2
func countCommonAnswers(in group: Group) -> Int {
    let answerCounts = group.answers.reduce(into: [:]) { result, value in
        result[value, default: 0] += 1
    }
    return answerCounts.filter { $0.value == group.size }.count
}

let partTwoCount = groups.map(countCommonAnswers).reduce(0, +)
print("The answer to part two: \(partTwoCount)") // 3229
