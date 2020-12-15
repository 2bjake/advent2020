let values = [1, 17, 0, 10, 18, 11, 6]

var counter = 0

var lastTurnByNumber = [Int: Int]()

for value in values {
    counter += 1
    lastTurnByNumber[value] = counter
}

var lastSpoken = values.last!

for _ in counter..<2020 {
    let lastTurnSpoken = lastTurnByNumber[lastSpoken, default: counter]
    lastTurnByNumber[lastSpoken] = counter
    lastSpoken = counter - lastTurnSpoken
    counter += 1
}

print(lastSpoken)
