
import Foundation

let input = "326519478"

func partOne() {
    let values = input.compactMap { Int(String($0)) }
    var buffer = CircularBuffer(values)
    for _ in 0..<100 {
        buffer.move(3)
    }
    let labels = buffer.getNext(values.count - 1, after: 1).map(String.init).joined(separator: "")
    print("answer to part one: \(labels)") // 25368479
}
partOne()

func findDestinationNode(of currentNode: Node) -> Node {
    let selectedValues = [currentNode.next.value, currentNode.next.next.value, currentNode.next.next.next.value]
    var candidate = currentNode.lower!
    while selectedValues.contains(candidate.value) {
        candidate = candidate.lower
    }
    return candidate
}

func partTwo() {
    let (frontNode, oneNode) = buildNodes(input)
    var currentNode = frontNode

    for _ in 0..<10_000_000 {
        let firstSelectedNode = currentNode.next!
        let lastSelectedNode = firstSelectedNode.next.next!
        let destinationNode = findDestinationNode(of: currentNode)

        currentNode.next = lastSelectedNode.next
        lastSelectedNode.next = destinationNode.next
        destinationNode.next = firstSelectedNode
        currentNode = currentNode.next
    }
    let product = oneNode.next.value * oneNode.next.next.value
    print("answer to part two: \(product)") // 44541319250
}
partTwo()
