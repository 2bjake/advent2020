import Foundation

extension Sequence {
    func count(where predicate: (Element) -> Bool) -> Int {
        filter(predicate).count
    }
}

let entries = input.split(separator: "\n").compactMap(Entry.init)

print("valid count for part one: \(entries.count(where: \.isValidForPartOne))") // 586
print("valid count for part two: \(entries.count(where: \.isValidForPartTwo))") // 352
