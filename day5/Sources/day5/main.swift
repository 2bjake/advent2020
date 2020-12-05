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
    let row = boarding.prefix(8).reduce((0...127)[...]) { result, value in
        value == "F" ? result.dropBackHalf() : result.dropFrontHalf()
    }.first!

    let col = boarding.suffix(3).reduce((0...7)[...]) { result, value in
        value == "L" ? result.dropBackHalf() : result.dropFrontHalf()
    }.first!

    return row * 8 + col
}



let boardingPasses = input.split(separator: "\n").map(Array.init)

let seatIds = boardingPasses.map(seatId)

print("answer to part one: \(seatIds.max())")

func missingSeat(in seatIds: [Int]) -> Int? {
    for i in 0..<(seatIds.count - 1) {
        if seatIds[i + 1] != seatIds[i] + 1 {
            return seatIds[i] + 1
        }
    }
    return nil
}

print("answer to part two: \(missingSeat(in: seatIds.sorted()))")
