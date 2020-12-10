import Foundation

var values = input.components(separatedBy: "\n").compactMap(Int.init).sorted()
values.insert(0, at: 0) // add outlet
values.append(values.last! + 3) // add device

// part 1

func calculateDifferenceProduct(in values: [Int]) -> Int {
    var counts = [0, 0, 0, 0]

    for i in 0..<(values.count - 1) {
        let diff = values[i + 1] - values[i]
        counts[diff] += 1
    }

    return counts[3] * counts[1]
}

print("answer for part one: \(calculateDifferenceProduct(in: values))") // 1848

// part 2

func calculateCombinations(in values: [Int]) -> Int {
    var arrangementsFromJoltage = [Int: Int]()
    arrangementsFromJoltage[values.last!] = 1

    for i in (0..<(values.count - 1)).reversed() {
        let curValue = values[i]
        let nextValues = values.dropFirst(i + 1).prefix(3).filter { $0 - curValue <= 3 }
        let arrangementCounts = nextValues.compactMap { arrangementsFromJoltage[$0] }
        arrangementsFromJoltage[curValue] = arrangementCounts.reduce(0, +)
    }
    return arrangementsFromJoltage[values[0]]!
}

print("answer to part 2: \(calculateCombinations(in: values))") // 8099130339328
