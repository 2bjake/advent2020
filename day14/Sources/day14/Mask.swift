//
//  Mask.swift
//
//
//  Created by Jake Foster on 12/14/20.
//

import Foundation

struct Mask {
    let andMask: UInt64
    let orMask: UInt64

    func apply(to value: UInt64) -> UInt64 {
        value & andMask | orMask
    }
}

//infix operator &|
//
//func &| (value: UInt64, mask: Mask) -> UInt64 {
//    value & mask.andMask | mask.orMask
//}

extension Mask {
    init?(_ source: String) {
        guard let andMask = UInt64(source.replacingOccurrences(of: "X", with: "1"), radix: 2),
              let orMask = UInt64(source.replacingOccurrences(of: "X", with: "0"), radix: 2) else {
            return nil
        }
        self.init(andMask: andMask, orMask: orMask)
    }
}

extension Mask: CustomStringConvertible {
    var description: String {
        "Mask{ andMask: \(String(andMask, radix: 2)), orMask: \(String(orMask, radix: 2)) }"
    }
}
