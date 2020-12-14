//
//  Instruction.swift
//
//
//  Created by Jake Foster on 12/14/20.
//

import Regex

enum Instruction {
    case mask(Mask)
    case put(address: UInt64, value: UInt64)
}

extension Instruction {
    private static let mask = "mask"
    private static let address = "address"
    private static let value = "value"

    private static let maskRegex = try! Regex(pattern: "mask = (.+)", groupNames: mask)
    private static let putRegex = try! Regex(pattern: #"mem\[(\d+)\] = (\d+)"#, groupNames: address, value)

    private static func makeMask(_ source: String) -> Self? {
        guard let maskMatch = maskRegex.findFirst(in: source),
              let maskStr = maskMatch.group(named: mask),
              let mask = Mask(maskStr) else {
            return nil
        }
        return .mask(mask)
    }

    private static func makePut(_ source: String) -> Self? {
        guard let putMatch = putRegex.findFirst(in: source),
              let addressStr = putMatch.group(named: address),
              let address = UInt64(addressStr),
              let valueStr = putMatch.group(named: value),
              let value = UInt64(valueStr) else {
            return nil
        }
        return .put(address: address, value: value)
    }

    init?(_ source: String) {
        if let mask = Self.makeMask(source) {
            self = mask
        } else if let put = Self.makePut(source) {
            self = put
        } else {
            return nil
        }
    }
}
