func findTwoProduct(in values: [Int], forSum sum: Int) -> Int? {
    let values = values.sorted()
    var front = 0
    var back = values.count - 1
    while front < back {
        let curSum = values[front] + values[back]
        if curSum == sum {
            return values[front] * values[back]
        } else if curSum < sum {
            front += 1
        } else {
            back -= 1
        }
    }
    return nil
}

func moveIdxWithSmallestDiff(in values: [Int], front: inout Int, back: inout Int) {
    let nextFront = front + 1
    let nextBack = back - 1
    guard nextFront < values.count && nextBack >= 0 else {
        fatalError("Off the end")
    }

    let frontDiff = values[nextFront] - values[front]
    let backDiff = values[back] - values[nextBack]
    if frontDiff < backDiff {
        front = nextFront
    } else {
        back = nextBack
    }
}

// assumes that smallest value + largest value < sum (which is the case in the provided input)
func findThreeProduct(in values: [Int], forSum sum: Int) -> Int? {
    let values = values.sorted()
    let valueSet = Set(values)

    var front = 0
    var back = values.count - 1
    while front < back {
        let partialSum = values[front] + values[back]
        let valueNeeded = sum - partialSum
        if valueSet.contains(valueNeeded) {
            return values[front] * values[back] * valueNeeded
        } else {
            moveIdxWithSmallestDiff(in: values, front: &front, back: &back)
        }
    }
    return nil
}

print("Part 1 answer: \(findTwoProduct(in: buildInput(), forSum: 2020)!)")
print("Part 2 answer: \(findThreeProduct(in: buildInput(), forSum: 2020)!)")
