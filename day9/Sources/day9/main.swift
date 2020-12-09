import Foundation

// part 1

func hasPair(in values: Set<Int>, forSum sum: Int) -> Bool {
    for value in values {
        let rest = sum - value
        if rest != value && values.contains(rest) {
            return true
        }
    }
    return false
}

func findValueWithNoPair(in values: [Int]) -> Int? {
    var subset = Set(values.prefix(25))

    var trailingIdx = 0
    var leadingIdx = subset.count

    while leadingIdx < values.count {
        guard hasPair(in: subset, forSum: values[leadingIdx]) else {
            return values[leadingIdx]
        }

        subset.remove(values[trailingIdx])
        trailingIdx += 1

        subset.insert(values[leadingIdx])
        leadingIdx += 1
    }
    return nil
}

// part 2

func findSumSlice(for target: Int, in values: [Int]) -> ArraySlice<Int> {
    var trailingIdx = 0
    var leadingIdx = 1
    var sum = values[trailingIdx] + values[leadingIdx]

    while leadingIdx < values.count {
        if sum == target {
            return values[trailingIdx...leadingIdx]
        } else if sum < target {
            leadingIdx += 1
            sum += values[leadingIdx]
        } else {
            sum -= values[trailingIdx]
            trailingIdx += 1
        }
    }
    return ArraySlice()
}

func sumMinMax(in values: ArraySlice<Int>) -> Int {
    guard let min = values.min(), let max = values.max() else { return 0 }
    return min + max
}

// solution

let values = input.components(separatedBy: "\n").compactMap(Int.init)

let target = findValueWithNoPair(in: values)!
print("answer to part one: \(target)") // 731031916

let sumSlice = findSumSlice(for: target, in: values)
print("answer to part two: \(sumMinMax(in: sumSlice))") // 93396727
