import Foundation
import Regex

func getContentColors(_ str: String) -> [String] {
    return str.split(using: "[.,]".r).compactMap {
        let regex = try? Regex(pattern: "\\d+ (.*) bags?", groups: .color)
        return regex?.findFirst(in: $0)?.group(.color)
    }
}

func buildBag<S: StringProtocol>(_ line: S) -> Bag? {
    let regex = try? Regex(pattern: "(.*) bags contain (.*).", groups: .color, .contents)
    let match = regex?.findFirst(in: String(line))
    guard let color = match?.group(.color), let contents = match?.group(.contents) else {
        return nil
    }
    return Bag(color: color, canContain: getContentColors(contents))
}

let registry = BagRegistry(bags: input.split(separator: "\n").compactMap(buildBag))
var ancestors: Set<Bag> = []

func collectAncestors(of bag: Bag) {
    for parent in bag.parents {
        ancestors.insert(parent)
        collectAncestors(of: parent)
    }
}

collectAncestors(of: registry.bags["shiny gold"]!)
print(ancestors.count)




