//
//  Ship.swift
//
//
//  Created by Jake Foster on 12/12/20.
//

struct Ship {
    var position = Point(x: 0, y: 0)
    var heading = Direction.east
    var waypoint = Point(x: 10, y: 1)
}

extension Ship {
    var distanceFromStart: Int { abs(position.x) + abs(position.y) }

    mutating func absoluteNavigate(instructions: [Instruction]) {
        for (action, value) in instructions {
            switch action {
                case .moveDirection(let direction):
                    position.move(direction: direction, units: value)
                case .moveForward:
                    position.move(direction: heading, units: value)
                case .turnLeft:
                    heading -= value
                case .turnRight:
                    heading += value
            }
        }
    }

    mutating func waypointNavigate(instructions: [Instruction]) {
        for (action, value) in instructions {
            switch action {
                case .moveDirection(let direction):
                    waypoint.move(direction: direction, units: value)
                case .moveForward:
                    position.move(direction: .east, units: waypoint.x * value)
                    position.move(direction: .north, units: waypoint.y * value)
                case .turnLeft:
                    waypoint.rotate(degrees: -value)
                case .turnRight:
                    waypoint.rotate(degrees: value)
            }
        }
    }
}
