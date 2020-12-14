//
//  Mask.swift
//
//
//  Created by Jake Foster on 12/14/20.
//

import Foundation

private extension Array {
    func replacingElement(at idx: Index, with values: Element...) -> [Array] {
        values.map {
            var result = self
            result[idx] = $0
            return result
        }
    }
}

struct Mask {
    private let floatIndicies: [Int]
    private let andMask: UInt64
    private let orMask: UInt64

    func applyV1(to value: UInt64) -> UInt64 {
        value & andMask | orMask
    }

    func applyV2(to value: UInt64) -> [UInt64] {
        let valueStr = String(value | orMask, radix: 2)
        var valueChars = Array(repeating: Character("0"), count: 36 - valueStr.count) // padding
        valueChars.append(contentsOf: valueStr)

        var values = [valueChars]
        for index in floatIndicies {
            values = values.flatMap { $0.replacingElement(at: index, with: "0", "1") }
        }

        return values.compactMap { UInt64(String($0), radix: 2) }
    }
}

extension Mask {
    init?(_ source: String) {
        guard let andMask = UInt64(source.replacingOccurrences(of: "X", with: "1"), radix: 2),
              let orMask = UInt64(source.replacingOccurrences(of: "X", with: "0"), radix: 2) else {
            return nil
        }

        let floatIndicies = Array(source).enumerated().compactMap { $0.element == "X" ? $0.offset : nil }

        self.init(floatIndicies: floatIndicies, andMask: andMask, orMask: orMask)
    }
}
