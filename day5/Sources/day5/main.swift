import Foundation

extension Collection {
    func dropFirstHalf() -> SubSequence {
        dropFirst(count/2)
    }

    func dropLastHalf() -> SubSequence {
        dropLast(count/2)
    }
}

func calculateSeatId(from boardingPass: [Character]) -> Int {
    let row = boardingPass.prefix(8).reduce((0...127)[...]) { range, value in
        value == "F" ? range.dropLastHalf() : range.dropFirstHalf()
    }.first!

    let col = boardingPass.suffix(3).reduce((0...7)[...]) { range, value in
        value == "L" ? range.dropLastHalf() : range.dropFirstHalf()
    }.first!

    return row * 8 + col
}

let boardingPasses = input.split(separator: "\n").map(Array.init)
let seatIds = boardingPasses.map(calculateSeatId)

print("answer to part one: \(seatIds.max())")

func findMissingSeat(in seatIds: [Int]) -> Int? {
    let seatIds = seatIds.sorted()
    for i in 0..<(seatIds.count - 1) {
        let nextSeatId = seatIds[i] + 1
        if seatIds[i + 1] != nextSeatId {
            return nextSeatId
        }
    }
    return nil
}

print("answer to part two: \(findMissingSeat(in: seatIds))")
