import Foundation

struct Instruction {
    enum Operation: String { case acc, jmp, nop }
    var operation: Operation
    let argument: Int
}

extension Instruction {
    init?<S: StringProtocol>(_ str: S) {
        let parts = str.components(separatedBy: " ")
        guard parts.count == 2,
              let operation = Operation(rawValue: parts[0]),
              let argument = Int(parts[1]) else {
            return nil
        }
        self.init(operation: operation, argument: argument)
    }

    mutating func flip() {
        switch operation {
            case .nop: operation = .jmp
            case .jmp: operation = .nop
            case .acc: break
        }
    }
}

typealias ExecutionResult = (successful: Bool, accumulator: Int, executedIndicies: Set<Int>)

func execute(_ instructions: [Instruction]) -> ExecutionResult {
    var accumulator = 0
    var index = 0
    var executedIndicies: Set<Int> = []

    while index >= 0 && index < instructions.count && !executedIndicies.contains(index) {
        executedIndicies.insert(index)
        let instruction = instructions[index]
        switch instruction.operation {
            case .jmp: index += instruction.argument
            case .acc: accumulator += instruction.argument; fallthrough
            case .nop: index += 1
        }

    }
    return (index == instructions.count, accumulator, executedIndicies)
}

let instructions = input.split(separator: "\n").compactMap(Instruction.init)

// part 1
print("answer to part one: \(execute(instructions).accumulator)") // 1671

// part 2
func findCorrectedResult(_ instructions: [Instruction]) -> Int? {
    let result = execute(instructions)
    guard !result.successful else { return result.accumulator }

    var instructions = instructions
    for index in result.executedIndicies {
        let operation = instructions[index].operation
        if operation == .jmp || operation == .nop {
            instructions[index].flip()

            let newResult = execute(instructions)
            if newResult.successful {
                return newResult.accumulator
            } else {
                instructions[index].flip() // flip back
            }
        }
    }
    return nil
}

print("answer to part two: \(findCorrectedResult(instructions)!)") // 892
