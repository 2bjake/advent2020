import Foundation
import Regex

extension Int {
    init?(_ source: String?) {
        guard let source = source else { return nil }
        self.init(source)
    }
}

func buildRanges() -> [ClosedRange<Int>] {
    let fieldsRegex = try! Regex(pattern: #".*: (\d+)-(\d+) or (\d+)-(\d+)\n"#)
    let matches = fieldsRegex.findAll(in: fields)
    return matches.flatMap { match -> [ClosedRange<Int>] in
        guard let firstLower = Int(match.group(at: 1)),
              let firstUpper = Int(match.group(at: 2)),
              let secondLower = Int(match.group(at: 3)),
              let secondUpper = Int(match.group(at: 4)) else {
            return []
        }
        return [firstLower...firstUpper, secondLower...secondUpper]
    }
}

let fieldRanges = buildRanges()
let fieldValues = otherTickets.split(using: #"[\n,]"#.r).compactMap(Int.init)

let errorRate = fieldValues.filter { value in
    for range in fieldRanges {
        if range.contains(value) {
            return false
        }
    }
    return true
}.reduce(0, +)

print(errorRate)
