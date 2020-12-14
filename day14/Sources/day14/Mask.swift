//
//  Mask.swift
//
//
//  Created by Jake Foster on 12/14/20.
//

import Foundation

struct Mask {
    let floatIndicies: [Int]
    let andMask: UInt64
    let orMask: UInt64

    func applyV1(to value: UInt64) -> UInt64 {
        value & andMask | orMask
    }

    private func replaceFirstX(in charArrays: [[Character]]) -> [[Character]] {
        charArrays.flatMap { charArray -> [[Character]] in
            guard let xIndex = charArray.firstIndex(of: "X") else { return [charArray] }
            var xToZero = charArray
            xToZero[xIndex] = "0"
            var xToOne = charArray
            xToOne[xIndex] = "1"
            return [xToZero, xToOne]
        }
    }

    func applyV2(to value: UInt64) -> [UInt64] {
        var valueChars = Array(String(value | orMask, radix: 2))
        let padding: [Character] = Array(repeating: "0", count: 36 - valueChars.count)
        valueChars.insert(contentsOf: padding, at: 0)
        for index in floatIndicies {
            valueChars[index] = "X"
        }

        var values = [valueChars]
        for _ in 0..<floatIndicies.count {
            values = replaceFirstX(in: values)
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

extension Mask: CustomStringConvertible {
    var description: String {
        "Mask{ andMask: \(String(andMask, radix: 2)), orMask: \(String(orMask, radix: 2)) }"
    }
}
