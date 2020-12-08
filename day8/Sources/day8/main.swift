import Foundation

struct Instruction {
    enum Operation: String { case acc, jmp, nop }
    let op: Operation
    let arg: Int
}

extension Instruction {
    init?<S: StringProtocol>(_ str: S) {
        let parts = str.components(separatedBy: " ")
        guard parts.count == 2,
              let op = Operation(rawValue: parts[0]),
              let arg = Int(parts[1]) else {
            return nil
        }
        self.init(op: op, arg: arg)
    }
}

func findAccBeforeLoop(_ instructions: [Instruction]) -> Int {
    var accumulator = 0
    var index = 0
    var executedIndicies: Set<Int> = []

    while !executedIndicies.contains(index) {
        executedIndicies.insert(index)
        let arg = instructions[index].arg
        switch instructions[index].op {
            case .jmp: index += arg
            case .acc: accumulator += arg; fallthrough
            case .nop: index += 1
        }
    }
    return accumulator
}

let instructions = input.split(separator: "\n").compactMap(Instruction.init)

print(findAccBeforeLoop(instructions))
