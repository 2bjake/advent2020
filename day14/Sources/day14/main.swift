import Foundation

typealias PutHandler = (_ address: UInt64, _ value: UInt64, _ mask: Mask?, _ memory: inout [UInt64: UInt64]) -> Void

func runInstructions(_ instructions: [Instruction], with putHandler: PutHandler) -> UInt64 {
    var curMask: Mask?
    var memory = [UInt64: UInt64]()

    for instruction in instructions {
        switch instruction {
            case .mask(let mask):
                curMask = mask
            case .put(let address, let value):
                putHandler(address, value, curMask, &memory)
        }
    }
    return memory.values.reduce(0, +)
}

let instructions = input.components(separatedBy: "\n").compactMap(Instruction.init)

let partOneCount = runInstructions(instructions) { address, value, mask, memory in
    memory[address] = mask?.applyV1(to: value) ?? value
}
print("answer to part one: \(partOneCount)") // 14862056079561

let partTwoCount = runInstructions(instructions) { address, value, mask, memory in
    for address in mask?.applyV2(to: address) ?? [address] {
        memory[address] = value
    }
}
print("answer to part two: \(partTwoCount)") // 3296185383161
