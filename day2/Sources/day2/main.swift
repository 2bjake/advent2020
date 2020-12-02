import Foundation

func validCount(in lines: [String], where predicate: (Entry) -> Bool) -> Int {
    lines.compactMap(Entry.init).filter(predicate).count
}

let lines = input.split(separator: "\n").map(String.init)

let partOneCount = validCount(in: lines, where: \.isValidForPartOne)
print("valid count for part one: \(partOneCount))") // 586

let partTwoCount = validCount(in: lines, where: \.isValidForPartTwo)
print("valid count for part two: \(partTwoCount)") // 352

