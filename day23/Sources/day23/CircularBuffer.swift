//
//  CircleBuffer.swift
//
//
//  Created by Jake Foster on 12/23/20.
//

struct CircularBuffer {
    private var buffer: [Int]
    private var currentIndex: CircularIndex

    init(_ values: [Int]) {
        buffer = values
        currentIndex = CircularIndex(0, count: buffer.count)
    }
}

extension CircularBuffer {
    func getNext(_ n: Int, after: Int? = nil) -> [Int] {
        let baseIndex: CircularIndex
        if let after = after, let index = buffer.firstIndex(of: after) {
            baseIndex = CircularIndex(index, count: buffer.count)
        } else {
            baseIndex = currentIndex
        }
        return (1...n).map { buffer[baseIndex + $0] }
    }

    // this can be optimized given that we know all numbers
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

    mutating func move(_ n: Int) {
        let valuesToBeMoved = getNext(n)
        let destinationValue = findDestinationValue(moving: valuesToBeMoved)

        var destinationIndex = currentIndex + 1
        var sourceIndex = destinationIndex + n
        var hasMovedDestination = false

        while !hasMovedDestination {
            buffer[destinationIndex] = buffer[sourceIndex]
            hasMovedDestination = buffer[destinationIndex] == destinationValue
            destinationIndex += 1
            sourceIndex += 1
        }
        for i in 0..<n {
            buffer[destinationIndex + i] = valuesToBeMoved[i]
        }
        currentIndex += 1
    }
}
