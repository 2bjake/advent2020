import Foundation

func hasPair(in values: Set<Int>, forSum sum: Int) -> Bool {
    for value in values {
        let rest = sum - value
        if rest != value && values.contains(rest) {
            return true
        }
    }
    return false
}

let numbers = input.components(separatedBy: "\n").compactMap(Int.init)

func partOne() -> Int {
    var values = Set(numbers.prefix(25))
    var front = 0
    var back = 25

    while true {
        guard hasPair(in: values, forSum: numbers[back]) else {
            print("no pair for: \(numbers[back])")
            return numbers[back]
        }
        values.remove(numbers[front])
        values.insert(numbers[back])
        front += 1
        back += 1
    }
}

let target = partOne()
var front = 0
var back = 1
var sum = numbers[front] + numbers[back]
while true {
    if sum == target {
        let min = numbers[front...back].min()!
        let max = numbers[front...back].max()!
        print("answer to part two: \(min + max)")
        break
    } else if sum < target {
        back += 1
        sum += numbers[back]
    } else {
        sum -= numbers[front]
        front += 1
    }
}
