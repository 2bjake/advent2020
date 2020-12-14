import Foundation


let instructions = input.components(separatedBy: "\n").compactMap(Instruction.init)

var curMask: Mask?
var memory = [String: UInt64]()

for instruction in instructions {
    switch instruction {
        case .mask(let mask):
            curMask = mask
        case .put(let address, let value):
            memory[address] = curMask?.apply(to: value) ?? value
    }
}

print(memory.values.reduce(0, +))
