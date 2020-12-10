import Foundation

//extension Array {
//    func element(at idx: Int) -> Element? {
//        guard idx >= 0 && idx < count else { return nil }
//        return self[idx]
//    }
//}

var adapters = input.components(separatedBy: "\n").compactMap(Int.init).sorted()
adapters.insert(0, at: 0) // outlet
adapters.append(adapters.last! + 3) // device

var counts = Array(repeating: 0, count: 4)

for i in 1..<adapters.count {
    let diff = adapters[i] - adapters[i - 1]
    counts[diff] += 1
}
//counts[adapters[0]] += 1 // difference between outlet and first adapter
//counts[3] += 1 // difference between last adapater and device

print(counts[3] * counts[1]) // 1848

// part 2

func getNextsForAdapter(at idx: Int) -> [Int] {
    let lower = idx + 1
    let upper = idx + 3
    let range = (lower...upper).clamped(to: 0...(adapters.count - 1))

    return adapters[range].filter { $0 - adapters[idx] <= 3 }
}

var optionsByJoltage = [Int: Int]()
optionsByJoltage[adapters.last!] = 1


for i in (0...(adapters.count - 2)).reversed() {
    let nextAdapaters = getNextsForAdapter(at: i)
    let optionCounts = nextAdapaters.compactMap { optionsByJoltage[$0] }
    let options = optionCounts.reduce(0, +)
    optionsByJoltage[adapters[i]] = options
}

print(optionsByJoltage[adapters[0]])
