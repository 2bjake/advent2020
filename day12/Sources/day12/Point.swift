//
//  Point.swift
//
//
//  Created by Jake Foster on 12/12/20.
//

struct Point {
    var x: Int
    var y: Int
}

extension Point {
    mutating func move(direction: Direction, units: Int) {
        switch direction {
            case .north:
                y += units
            case .east:
                x += units
            case .south:
                y -= units
            case .west:
                x -= units
        }
    }

    mutating func rotate(degrees: Int) {
        let eastRotatedTo = Direction.east + degrees
        switch eastRotatedTo {
            case .north:
                self = Point(x: -y, y: x)
            case .east:
                break
            case .south:
                self = Point(x: y, y: -x)
            case .west:
                self = Point(x: -x, y: -y)
        }
    }
}
