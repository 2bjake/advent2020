//
//  Direction.swift
//
//
//  Created by Jake Foster on 12/12/20.
//

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
