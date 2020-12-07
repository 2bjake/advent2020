import Foundation
import Regex

func getContentColors(_ str: String) -> [Content] {
    return str.split(using: "[.,]".r).compactMap {
        let regex = try? Regex(pattern: "(\\d+) (.*) bags?", groups: .count, .color)
        let match = regex?.findFirst(in: $0)
        guard let count = Int(match?.group(.count) ?? ""), let color = match?.group(.color) else {
            return nil
        }
        return (count, color)
    }
}

func buildBag<S: StringProtocol>(_ line: S) -> Bag? {
    let regex = try? Regex(pattern: "(.*) bags contain (.*).", groups: .color, .contents)
    let match = regex?.findFirst(in: String(line))
    guard let color = match?.group(.color), let contents = match?.group(.contents) else {
        return nil
    }
    return Bag(color: color, contains: getContentColors(contents))
}

let registry = BagRegistry(bags: input.split(separator: "\n").compactMap(buildBag))

func partOne() {
    var ancestors: Set<Bag> = []
    func collectAncestors(of bag: Bag) {
        for parent in bag.parents {
            ancestors.insert(parent)
            collectAncestors(of: parent)
        }
    }

    collectAncestors(of: registry.bags["shiny gold"]!)
    print(ancestors.count)
}
partOne()

func partTwo() {
    func calculateCount(for bag: Bag) -> Int {
        var count = 0
        for childContent in bag.contains {
            if let child = registry.bags[childContent.color] {
                count += childContent.count * (calculateCount(for: child) + 1)
            }
        }
        return count
    }

    print(calculateCount(for: registry.bags["shiny gold"]!))
}

partTwo()




