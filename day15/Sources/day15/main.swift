
func findNthSpoken(_ n: Int, startingValues: [Int]) -> Int {
    var counter = 0

    var lastTurnByNumber = [Int: Int]()

    for value in startingValues {
        counter += 1
        lastTurnByNumber[value] = counter
    }

    var lastSpoken = startingValues.last!

    for _ in counter..<n {
        let lastTurnSpoken = lastTurnByNumber[lastSpoken, default: counter]
        lastTurnByNumber[lastSpoken] = counter
        lastSpoken = counter - lastTurnSpoken
        counter += 1
    }
    return lastSpoken
}

let input = [1, 17, 0, 10, 18, 11, 6]

print("answer to part one: \(findNthSpoken(2020, startingValues: input))") // 595
print("answer to part two: \(findNthSpoken(30_000_000, startingValues: input))") // 1708310

