//
//  Bag.swift
//
//
//  Created by Jake Foster on 12/7/20.
//

import Regex

struct Bag {
    typealias Content = (count: Int, color: String)

    let color: String
    let contents: [Content]
}

extension Bag {
    // group name constants
    private static let color = "color"
    private static let count = "count"
    private static let contents = "contents"

    private static func buildBagContents(_ str: String) -> [Content] {
        return str.split(using: "[.,]".r).compactMap {
            let regex = try? Regex(pattern: "(\\d+) (.*) bags?", groupNames: count, color)
            let match = regex?.findFirst(in: $0)
            guard let count = Int(match?.group(named: count) ?? ""), let color = match?.group(named: color) else {
                return nil
            }
            return (count, color)
        }
    }

    static func build<S: StringProtocol>(_ line: S) -> Bag? {
        let regex = try? Regex(pattern: "(.*) bags contain (.*)\\.", groupNames: color, contents)
        let match = regex?.findFirst(in: String(line))
        guard let color = match?.group(named: color), let contents = match?.group(named: contents) else {
            return nil
        }
        return Bag(color: color, contents: buildBagContents(contents))
    }
}
