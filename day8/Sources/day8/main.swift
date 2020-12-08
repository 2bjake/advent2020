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

    func flipped() -> Instruction {
        switch self.op {
            case .nop: return Instruction(op: .jmp, arg: arg)
            case .jmp: return Instruction(op: .nop, arg: arg)
            case .acc: return self
        }
    }
}

typealias ExecutionResult = (accumulator: Int, successful: Bool, executedIndicies: Set<Int>)

func execute(_ instructions: [Instruction]) -> ExecutionResult {
    var accumulator = 0
    var index = 0
    var executedIndicies: Set<Int> = []

    while !executedIndicies.contains(index) && index < instructions.count {
        executedIndicies.insert(index)
        let arg = instructions[index].arg
        switch instructions[index].op {
            case .jmp: index += arg
            case .acc: accumulator += arg; fallthrough
            case .nop: index += 1
        }

    }
    return (accumulator, index == instructions.count, executedIndicies)
}

let instructions = input.split(separator: "\n").compactMap(Instruction.init)

func partOne() {
    let result = execute(instructions)
    print(result.accumulator)
}

// part 2

func partTwo() -> Int? {
    let result = execute(instructions)
    for badInstructionIdx in result.executedIndicies {
        let badInstruction = instructions[badInstructionIdx]
        if badInstruction.op == .jmp || badInstruction.op == .nop {
            var newInstructions = instructions
            newInstructions[badInstructionIdx] = badInstruction.flipped()
            let newResult = execute(newInstructions)
            if newResult.successful {
                return newResult.accumulator
            }
        }
    }
    return nil
}

print(partTwo())
