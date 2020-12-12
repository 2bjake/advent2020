import Foundation

enum Direction: Int {
    case north = 0
    case east
    case south
    case west
}

extension Direction {
    init?(_ char: Character) {
        switch char {
            case "N": self = .north
            case "S": self = .south
            case "E": self = .east
            case "W": self = .west
            default: return nil
        }
    }
}

func +(direction: Direction, degrees: Int) -> Direction {
    var newRawDir = direction.rawValue + (degrees / 90)
    newRawDir %= 4
    if newRawDir < 0 {
        newRawDir += 4
    }
    return Direction(rawValue: newRawDir)!
}

func +=(direction: inout Direction, degrees: Int) {
    direction = direction + degrees
}

enum Action: Equatable {
    case moveDirection(Direction)
    case moveForward
    case turnLeft
    case turnRight
}

extension Action {
    init?(_ char: Character?) {
        guard let char = char else { return nil }
        if let direction = Direction(char) {
            self = .moveDirection(direction)
        } else if char == "L" {
            self = .turnLeft
        } else if char == "R" {
            self = .turnRight
        } else if char == "F" {
            self = .moveForward
        } else {
            return nil
        }
    }
}

typealias Instruction = (action: Action, value: Int)


let instructions: [Instruction] = input.split(separator: "\n").compactMap {
    guard let action = Action($0.first), let value = Int(String($0.dropFirst())) else {
        return nil
    }
    return (action, value)
}

struct Ship {
    typealias Point = (x: Int, y: Int)

    var position = Point(0, 0)
    var heading = Direction.east

    mutating func move(_ direction: Direction, distance: Int) {
        switch direction {
            case .north:
                position.x += distance
            case .east:
                position.y += distance
            case .south:
                position.x -= distance
            case .west:
                position.y -= distance
        }
    }

    mutating func performInstruction(_ instruction: Instruction) {
        switch instruction.action {
            case .moveDirection(let direction):
                move(direction, distance: instruction.value)
            case .moveForward:
                move(heading, distance: instruction.value)
            case .turnLeft:
                heading += -instruction.value
            case .turnRight:
                heading += instruction.value
        }
    }
}

var ship = Ship()
for instruction in instructions {
    ship.performInstruction(instruction)
}

print(abs(ship.position.x) + abs(ship.position.y))

