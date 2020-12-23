
import Foundation

struct CircleIndex {
    let value: Int
    let count: Int

    init(_ initial: Int, count: Int) {
        self.value = initial % count
        self.count = count
    }
}

extension CircleIndex: Comparable {
    static func < (lhs: CircleIndex, rhs: CircleIndex) -> Bool {
        lhs.value < rhs.value
    }
}

func +(idx: CircleIndex, value: Int) -> CircleIndex {
    CircleIndex((idx.value + value) % idx.count, count: idx.count)
}

func +=(idx: inout CircleIndex, value: Int) {
    idx = idx + value
}

extension Array {
    subscript(_ idx: CircleIndex) -> Element {
        get { self[idx.value] }
        set { self[idx.value] = newValue }
    }
}

struct FixedSizeBuffer {
    var buffer: [Int]
    private var currentIndex: CircleIndex

    init(_ values: [Int]) {
        buffer = values
        currentIndex = CircleIndex(0, count: buffer.count)
    }

    func getNext(_ n: Int) -> [Int] {
        (1...n).map { buffer[currentIndex + $0] }
    }

    func findDestinationValue(moving: [Int]) -> Int {
        var candidate = buffer[currentIndex]
        repeat {
            if candidate == 1 {
                candidate = buffer.count
            } else {
                candidate -= 1
            }
        } while moving.contains(candidate)
        return candidate
    }

    mutating func moveThree() {
        let moving = getNext(3)
        let destValue = findDestinationValue(moving: moving)

        var destIdx = currentIndex + 1
        var srcIdx = currentIndex + 4
        var movedDest = false
        while !movedDest {
            buffer[destIdx] = buffer[srcIdx]
            movedDest = buffer[destIdx] == destValue
            destIdx += 1
            srcIdx += 1
        }
        for i in 0..<moving.count {
            buffer[destIdx + i] = moving[i]
        }
        currentIndex += 1
    }

    func printLabelValues() {
        let oneIdx = buffer.firstIndex(of: 1)!
        for i in 1..<buffer.count {
            print(buffer[(oneIdx + i) % buffer.count], terminator: "")
        }
        print()
    }
}

let input = "326519478"
//let input = "389125467" // test input

func partOne() {
    var values = FixedSizeBuffer(input.compactMap { Int(String($0)) })
    for _ in 0..<100 {
        values.moveThree()
    }
    values.printLabelValues()
}
partOne() // 25368479

//func partTwo() {
//    var numbers = input.compactMap { Int(String($0)) }
//    numbers.reserveCapacity(1_000_000)
//    for i in 10...1_000_000 {
//        numbers.append(i)
//    }
//    var values = FixedSizeBuffer(numbers)
//    for i in 0..<9 {
//        values.moveThree()
//    }
//    print(values.buffer)
//    let oneIdx = values.buffer.firstIndex(of: 1)!
//    let first = values.buffer[(oneIdx + 1) % values.buffer.count]
//    let second = values.buffer[(oneIdx + 2) % values.buffer.count]
//    print("\(first) * \(second) = \(first * second))")
//}
//partTwo()
