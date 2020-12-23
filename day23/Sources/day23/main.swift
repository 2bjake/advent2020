
import Foundation

let input = "326519478"
//let input = "389125467" // test input

func partOne() {
    let values = input.compactMap { Int(String($0)) }
    var buffer = CircularBuffer(values)
    for _ in 0..<100 {
        buffer.move(3)
    }
    let labels = buffer.getNext(values.count - 1, after: 1).map(String.init).joined(separator: "")
    print("answer to part one: \(labels)") // 25368479
}
partOne()

func partTwo() {
    var values = input.compactMap { Int(String($0)) }
    values.reserveCapacity(1_000_000)
    for i in 10...1_000_000 {
        values.append(i)
    }
    var buffer = CircularBuffer(values)
    for i in 0..<10_000_000 {
        print(i)
        buffer.move(3)
    }
    let product = buffer.getNext(2, after: 1).reduce(1, *)
    print("answer to part two: \(product)")
}
partTwo()
