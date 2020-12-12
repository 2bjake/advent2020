//
//  Action.swift
//
//
//  Created by Jake Foster on 12/12/20.
//

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
