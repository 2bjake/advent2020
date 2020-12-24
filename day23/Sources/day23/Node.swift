//
//  Node.swift
//
//
//  Created by Jake Foster on 12/24/20.
//

class Node {
    let value: Int
    var next: Node!
    weak var lower: Node!

    internal init(value: Int, next: Node? = nil, lower: Node? = nil) {
        self.value = value
        self.next = next
        self.lower = lower
    }
}

func buildNodes(_ source: String) -> (frontNode: Node, oneNode: Node) {
    let lastNode = Node(value: 1_000_000)

    var curNode: Node!
    var prevNode = lastNode

    for i in (10..<lastNode.value).reversed() {
        curNode = Node(value: i, next: prevNode)
        prevNode.lower = curNode
        prevNode = curNode
    }

    let values = source.compactMap { Int(String($0)) }
    let nodesByValue = values.reduce(into: [:]) { result, value in
        result[value] = Node(value: value)
    }

    for i in 0..<values.count {
        let value = values[i]
        let node = nodesByValue[value]!

        if value == 1 {
            node.lower = lastNode
        } else {
            node.lower = nodesByValue[value - 1]
        }

        if i < values.count - 1 {
            node.next = nodesByValue[values[i + 1]]
        } else {
            node.next = curNode
        }
    }

    curNode.lower = nodesByValue[9]

    let frontNode = nodesByValue[values[0]]!
    lastNode.next = frontNode
    let oneNode = nodesByValue[1]!
    return (frontNode, oneNode)
}

