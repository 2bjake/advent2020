
let pubKeys = [10943862, 12721030]

var loopSizeByPubKeys = [Int: Int]()

func generatePubKey(subject: Int, loopSize: Int, startingAt value: Int = 1) -> Int {
    var value = value
    for _ in 0..<loopSize {
        value *= subject
        value %= 20201227
    }
    return value
}

var value = 1
var i = 1
while loopSizeByPubKeys.count < 2 {
    value = generatePubKey(subject: 7, loopSize: 1, startingAt: value)
    if pubKeys.contains(value) {
        print("key \(value) uses loop size \(i)")
        loopSizeByPubKeys[value] = i
    }
    i += 1
}

let (pubKey, loopSize) = loopSizeByPubKeys.min { $0.value < $1.value }!
let otherPubKey = pubKeys.first { $0 != pubKey }!

print("generating result with key \(otherPubKey) and loopSize \(loopSize)")
let result = generatePubKey(subject: otherPubKey, loopSize: loopSize)
print("answer to part one: \(result)") // 5025281
