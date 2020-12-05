import Foundation

extension Collection {
    func dropBackHalf() -> SubSequence {
        dropLast(count/2)
    }

    func dropFrontHalf() -> SubSequence {
        dropFirst(count/2)
    }
}

func seatId(from boarding: [Character]) -> Int {
    let row = boarding.prefix(8).reduce((0...127)[...]) { range, value in
        value == "F" ? range.dropBackHalf() : range.dropFrontHalf()
    }.first!

    let col = boarding.suffix(3).reduce((0...7)[...]) { range, value in
        value == "L" ? range.dropBackHalf() : range.dropFrontHalf()
    }.first!

    return row * 8 + col
}

let boardingPasses = input.split(separator: "\n").map(Array.init)
let seatIds = boardingPasses.map(seatId)

print("answer to part one: \(seatIds.max())")

func missingSeat(in seatIds: [Int]) -> Int? {
    let seatIds = seatIds.sorted()
    for i in 0..<(seatIds.count - 1) {
        let nextSeatId = seatIds[i] + 1
        if seatIds[i + 1] != nextSeatId {
            return nextSeatId
        }
    }
    return nil
}

print("answer to part two: \(missingSeat(in: seatIds))")
