import Foundation

let registry = BagRegistry(bags: input.split(separator: "\n").compactMap(Bag.build))

func partOne() {
    var ancestors: Set<String> = []

    func collectAncestors(of bag: Bag) {
        for parent in registry.retrieveParents(of: bag) {
            ancestors.insert(parent.color)
            collectAncestors(of: parent)
        }
    }

    collectAncestors(of: registry.shinyGoldBag)
    print("answer to part one: \(ancestors.count)") // 372
}
partOne()

func partTwo() {
    func calculateCount(for bag: Bag) -> Int {
        bag.contents.reduce(0) { result, content in
            guard let child = registry.retrieveBag(withColor: content.color) else { return result }
            return result + content.count * (calculateCount(for: child) + 1)
        }
    }

    print("answer to part two: \(calculateCount(for: registry.shinyGoldBag))") // 8015
}
partTwo()
