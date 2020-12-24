//
//  OptimizedCircleBuffer.swift
//
//
//  Created by Jake Foster on 12/23/20.
//

import Foundation

func copyMemory<T>(in bufferPointer: UnsafeMutableBufferPointer<T>, from sourceIndicies: ClosedRange<Int>, to destinationIndex: Int) {
    let size = MemoryLayout<T>.size
    let frontPointer = UnsafeMutableRawPointer(bufferPointer.baseAddress!)
    let sourcePointer = frontPointer + sourceIndicies.lowerBound * size
    let sourceLength = sourceIndicies.count * size
    let destinationPointer = frontPointer + destinationIndex * size
    destinationPointer.copyMemory(from: sourcePointer, byteCount: sourceLength)
}

struct OptimizedCircularBuffer {
    private var buffer: ContiguousArray<Int>
    private var currentIndex: CircularIndex

    init(_ values: [Int], fillingTo: Int? = nil) {
        let capacity = fillingTo ?? values.count

        buffer = ContiguousArray.init(unsafeUninitializedCapacity: capacity) { pointer, count in
            var i = 0
            while i < values.count {
                pointer[i] = values[i]
                i += 1
            }
            while i < capacity {
                pointer[i] = i + 1
                i += 1
            }
            count = capacity
        }
        currentIndex = CircularIndex(0, count: buffer.count)
    }
}

extension OptimizedCircularBuffer {
    func getNext(_ n: Int, after: Int? = nil) -> [Int] {
        let baseIndex: CircularIndex
        if let after = after, let index = buffer.firstIndex(of: after) {
            baseIndex = CircularIndex(index, count: buffer.count)
        } else {
            baseIndex = currentIndex
        }
        return (1...n).map { buffer[baseIndex + $0] }
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

    mutating func move(_ n: Int) {
        let valuesToBeMoved = getNext(n)

        let destinationValue = findDestinationValue(moving: valuesToBeMoved)
        let destinationIndex = buffer.firstIndex(of: destinationValue)!

        let bufferCount = buffer.count
        buffer.withUnsafeMutableBufferPointer {
            var cIndex = currentIndex.value
            var dIndex = destinationIndex

            if dIndex < cIndex {
                // if the valuesToBeMoved spans the ends of the buffer
                // shift so that it no longer does
                if cIndex + n >= bufferCount {
                    let sourceStartIndex = (cIndex + n + 1) % bufferCount
                    let sourceEndIndex = bufferCount - 1
                    let destinationIndex = 0
                    copyMemory(in: $0, from: (sourceStartIndex ... sourceEndIndex), to: destinationIndex)
                    cIndex -= sourceStartIndex
                    dIndex -= sourceStartIndex
                }

                let sourceIndicies = (dIndex + 1 ... cIndex )
                let destinationIndex = dIndex + n + 1
                copyMemory(in: $0, from: sourceIndicies, to: destinationIndex)
                cIndex += n
            } else { // cIndex < dIndex
                let sourceStartIndex = cIndex + n + 1
                let sourceIndicies = (sourceStartIndex ... dIndex)
                let destinationIndex = cIndex + 1
                copyMemory(in: $0, from: sourceIndicies, to: destinationIndex)
                dIndex -= n
            }
            for i in 0..<n {
                $0[dIndex + i + 1] = valuesToBeMoved[i]
            }
            self.currentIndex = CircularIndex(cIndex, count: bufferCount)
        }
        currentIndex += 1
    }
}
