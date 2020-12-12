import Foundation

struct Ship {
    var position = Point(x: 0, y: 0)
    var heading = Direction.east
    var waypoint = Point(x: 10, y: 1)
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
                ship.position.move(direction: direction, units: instruction.value)
            case .moveForward:
                ship.position.move(direction: ship.heading, units: instruction.value)
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
                ship.waypoint.move(direction: direction, units: instruction.value)
            case .moveForward:
                ship.position.move(direction: .east, units: ship.waypoint.x * instruction.value)
                ship.position.move(direction: .north, units: ship.waypoint.y * instruction.value)
            case .turnLeft:
                ship.waypoint.rotate(degrees: -instruction.value)
            case .turnRight:
                ship.waypoint.rotate(degrees: instruction.value)
        }
    }

    print(abs(ship.position.x) + abs(ship.position.y)) // 28591
}
partTwo()

