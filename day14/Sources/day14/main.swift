import Foundation


let instructions = input.components(separatedBy: "\n").compactMap(Instruction.init)

func partOne() {
    var curMask: Mask?
    var memory = [UInt64: UInt64]()

    for instruction in instructions {
        switch instruction {
            case .mask(let mask):
                curMask = mask
            case .put(let address, let value):
                memory[address] = curMask?.applyV1(to: value) ?? value
        }
    }

    print("answer to part one: \(memory.values.reduce(0, +))") // 14862056079561
}
partOne()


var curMask: Mask?
var memory = [UInt64: UInt64]()

for instruction in instructions {
    switch instruction {
        case .mask(let mask):
            curMask = mask
        case .put(let address, let value):
            for address in curMask?.applyV2(to: address) ?? [address] {
                memory[address] = value
            }
    }
}

print("answer to part two: \(memory.values.reduce(0, +))") // 3296185383161
