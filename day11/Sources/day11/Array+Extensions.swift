//
//  Array+Extensions.swift
//
//
//  Created by Jake Foster on 12/11/20.
//

import Foundation

typealias Point = (x: Int, y: Int)
typealias Slope = (Δx: Int, Δy: Int)

func +(point: Point, slope: Slope) -> Point {
    Point(x: point.x + slope.Δx, y: point.y + slope.Δy)
}

func +=(point: inout Point, slope: Slope) {
    point = point + slope
}

extension Array where Element: RandomAccessCollection & MutableCollection, Element.Index == Int {
    typealias BaseElement = Element.Element

    subscript(_ point: Point) -> BaseElement {
        get { self[point.y][point.x] }
        set { self[point.y][point.x] = newValue }
    }

    func element(at point: Point) -> BaseElement? {
        guard indices.contains(point.y) && self[0].indices.contains(point.x) else { return nil }
        return self[point]
    }

    func adjacentElements(of point: Point) -> [BaseElement] {
        var neighbors = [BaseElement]()
        for x in -1...1 {
            for y in -1...1 {
                let newPoint = point + (x, y)
                if newPoint != point, let neighbor = element(at: newPoint) {
                    neighbors.append(neighbor)
                }
            }
        }
        return neighbors
    }

    private func lineOfSightElement(of point: Point, with slope: Slope, where predicate: (BaseElement) -> Bool ) -> BaseElement? {
        var curPoint = point + slope
        while let space = element(at: curPoint) {
            if predicate(space) {
                return space
            }
            curPoint += slope
        }
        return nil
    }

    func lineOfSightElements(of point: Point, where predicate: (BaseElement) -> Bool ) -> [BaseElement] {
        let slopes = [(0, 1), (0, -1), (1, 0), (1, 1), (1, -1), (-1, 0), (-1, 1), (-1, -1)]
        return slopes.compactMap { lineOfSightElement(of: point, with: $0, where: predicate) }
    }
}

extension Array where Element: Sequence {
    var allPoints: [Point] {
        var result = [Point]()
        for x in 0..<spaces[0].count {
            for y in 0..<spaces.count {
                result.append(Point(x, y))
            }
        }
        return result
    }
}

extension Sequence {
    func count(_ predicate: (Element) -> Bool) -> Int {
        self.filter(predicate).count
    }
}

extension Sequence where Element: Sequence {
    func count(where predicate: (Element.Element) -> Bool) -> Int {
        flatMap { $0 }.count(predicate)
    }
}
