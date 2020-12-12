import Foundation

enum Direction: Int {
    case north
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

typealias Point = (x: Int, y: Int)

func movePoint(_ point: inout Point, direction: Direction, units: Int) {
    switch direction {
        case .north:
            point.y += units
        case .east:
            point.x += units
        case .south:
            point.y -= units
        case .west:
            point.x -= units
    }
}

func rotatePoint(_ point: inout Point, degrees: Int) {
    let eastRotatedTo = Direction.east + degrees
    switch eastRotatedTo {
        case .north:
            point = Point(x: -point.y, y: point.x)
        case .east:
            break
        case .south:
            point = Point(x: point.y, y: -point.x)
        case .west:
            point = Point(x: -point.x, y: -point.y)
    }
}

struct Ship {
    var position = Point(0, 0)
    var heading = Direction.east
    var waypoint = Point(10, 1)
}

typealias Instruction = (action: Action, value: Int)

let instructions: [Instruction] = input.split(separator: "\n").compactMap {
    guard let action = Action($0.first), let value = Int(String($0.dropFirst())) else {
        return nil
    }
    return (action, value)
}

func partOne() {
    var ship = Ship()
    for instruction in instructions {
        switch instruction.action {
            case .moveDirection(let direction):
                movePoint(&ship.position, direction: direction, units: instruction.value)
            case .moveForward:
                movePoint(&ship.position, direction: ship.heading, units: instruction.value)
            case .turnLeft:
                ship.heading += -instruction.value
            case .turnRight:
                ship.heading += instruction.value
        }
    }

    print(abs(ship.position.x) + abs(ship.position.y)) // 381
}
partOne()

func partTwo() {
    var ship = Ship()
    for instruction in instructions {
        switch instruction.action {
            case .moveDirection(let direction):
                movePoint(&ship.waypoint, direction: direction, units: instruction.value)
            case .moveForward:
                movePoint(&ship.position, direction: .east, units: ship.waypoint.x * instruction.value)
                movePoint(&ship.position, direction: .north, units: ship.waypoint.y * instruction.value)
            case .turnLeft:
                rotatePoint(&ship.waypoint, degrees: -instruction.value)
            case .turnRight:
                rotatePoint(&ship.waypoint, degrees: instruction.value)
        }
    }

    print(abs(ship.position.x) + abs(ship.position.y))
}
partTwo()

