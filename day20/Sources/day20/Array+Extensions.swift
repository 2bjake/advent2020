//
//  Array+Extensions.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    func buildColumn(at idx: Index) -> [Element.Element] {
        (0..<count).map { self[$0][idx] }
    }

    func buildColumns() -> [[Element.Element]] {
        guard !isEmpty else { return [[]] }
        return (0..<self[0].count).map(buildColumn)
    }
}

extension Array where Element: RandomAccessCollection & MutableCollection, Element.Index == Int {

    private mutating func swapAt(_ i1: Int, _ j1: Int, _ i2: Int, _ j2: Int) {
        let tmp = self[i1][j1]
        self[i1][j1] = self[i2][j2]
        self[i2][j2] = tmp
    }

    private mutating func flip(horizontally: Bool) {
        for i in 0..<count {
            var front = 0
            var back = count - 1
            while front < back {
                if horizontally {
                    swapAt(front, i, back, i)
                } else {
                    swapAt(i, front, i, back)
                }
                front += 1
                back -= 1
            }
        }
    }

    mutating func flipVertically() {
        flip(horizontally: false)
    }

    mutating func flipHorizontally() {
        flip(horizontally: true)
    }

    private mutating func preRotate() {
        for cur in 0..<count {
            for i in 0..<count-cur {
                swapAt(cur, cur + i, cur + i, cur)
            }
        }
    }

    mutating func rotateRight() {
        preRotate()
        flipVertically()
    }

    mutating func rotateLeft() {
        preRotate()
        flipHorizontally()
    }
}
