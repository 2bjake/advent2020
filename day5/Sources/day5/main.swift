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

/// Alt: Define "find missing" as a generic method on Collection. There's nothing seat-specific about the algorithm.

extension Collection where Element: Comparable & Strideable {
    /// Returns the first value that is not present in the `Sequence`
    /// while traversing `Element`s in order of value.
    ///
    /// Complexity: O(n log n), where n is the length of the sequence.
    func findFirstMissing() -> Element? where Element.Stride: ExpressibleByIntegerLiteral {
        let ordered = sorted()
        for i in 0..<(ordered.count - 1) {
            let nextValue = ordered[i].advanced(by: 1)
            if ordered[i + 1] != nextValue {
                return nextValue
            }
        }
        return nil
    }
}

print("answer to part two: \(seatIds.findFirstMissing())")

/// Alt: Use subtraction from range to find missing value - O(n) solution

func findMissingSeatWitRange(in seatIds: [Int]) -> Int? {
    guard let lowerBound = seatIds.min(),
          let upperBound = seatIds.max() else { return nil }

    return Set(lowerBound...upperBound).subtracting(seatIds).min()
}

print("answer to part two: \(findMissingSeatWitRange(in: seatIds))")

/// Alt: O(n) solution on Collection

extension Collection where Element: Hashable & Strideable {
    /// Returns the first value that is not present in the `Sequence`
    /// while traversing `Element`s in order of value.
    ///
    /// Complexity: O(n), where n is the length of the sequence.
    func findFirstMissingLinear() -> Element? where Element.Stride: SignedInteger {
        guard let lowerBound = self.min(),
              let upperBound = self.max() else { return nil }

        return Set(lowerBound...upperBound).subtracting(self).min()
    }
}

print("answer to part two: \(seatIds.findFirstMissingLinear())")
