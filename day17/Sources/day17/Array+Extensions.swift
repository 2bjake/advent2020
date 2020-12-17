//
//  Array+Extensions.swift
//
//
//  Created by Jake Foster on 12/17/20.
//

import Foundation

typealias Point = (x: Int, y: Int, z: Int)
typealias Slope = (Δx: Int, Δy: Int, Δz: Int)

func +(point: Point, slope: Slope) -> Point {
    Point(x: point.x + slope.Δx, y: point.y + slope.Δy, z: point.z + slope.Δz)
}

func +=(point: inout Point, slope: Slope) {
    point = point + slope
}

extension Array where Element: RandomAccessCollection & MutableCollection, Element.Index == Int, Element.Element: RandomAccessCollection & MutableCollection, Element.Element.Index == Int {
    typealias BaseElement = Element.Element.Element

    subscript(_ point: Point) -> BaseElement {
        get { self[point.y][point.x][point.z] }
        set { self[point.y][point.x][point.z] = newValue }
    }

    func element(at point: Point) -> BaseElement? {
        guard indices.contains(point.y) && self[0].indices.contains(point.x) && self[0][0].indices.contains(point.z) else { return nil }
        return self[point]
    }

    func adjacentElements(of point: Point) -> [BaseElement] {
        var neighbors = [BaseElement]()
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    let newPoint = point + (x, y, z)
                    if newPoint != point, let neighbor = element(at: newPoint) {
                        neighbors.append(neighbor)
                    }
                }
            }
        }
        return neighbors
    }

    var allPoints: [Point] {
        var result = [Point]()
        for x in 0..<self[0].count {
            for y in 0..<self.count {
                for z in 0..<self[0][0].count {
                    result.append(Point(x, y, z))
                }
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

// =============

typealias HyperPoint = (x: Int, y: Int, z: Int, w: Int)
typealias HyperSlope = (Δx: Int, Δy: Int, Δz: Int, Δw: Int)

func +(point: HyperPoint, slope: HyperSlope) -> HyperPoint {
    HyperPoint(x: point.x + slope.Δx, y: point.y + slope.Δy, z: point.z + slope.Δz, w: point.w + slope.Δw)
}

func +=(point: inout HyperPoint, slope: HyperSlope) {
    point = point + slope
}

extension Array where Element: RandomAccessCollection & MutableCollection, Element.Index == Int, Element.Element: RandomAccessCollection & MutableCollection, Element.Element.Index == Int, Element.Element.Element: RandomAccessCollection & MutableCollection, Element.Element.Element.Index == Int {
    typealias HyperBaseElement = Element.Element.Element.Element

    subscript(_ point: HyperPoint) -> HyperBaseElement {
        get { self[point.y][point.x][point.z][point.w] }
        set { self[point.y][point.x][point.z][point.w] = newValue }
    }

    func element(at point: HyperPoint) -> HyperBaseElement? {
        guard indices.contains(point.y) && self[0].indices.contains(point.x) && self[0][0].indices.contains(point.z) && self[0][0][0].indices.contains(point.w) else { return nil }
        return self[point]
    }

    func adjacentElements(of point: HyperPoint) -> [HyperBaseElement] {
        var neighbors = [HyperBaseElement]()
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    for w in -1...1 {
                        let newPoint = point + (x, y, z, w)
                        if newPoint != point, let neighbor = element(at: newPoint) {
                            neighbors.append(neighbor)
                        }
                    }
                }
            }
        }
        return neighbors
    }

    var allHyperPoints: [HyperPoint] {
        var result = [HyperPoint]()
        for x in 0..<self[0].count {
            for y in 0..<self.count {
                for z in 0..<self[0][0].count {
                    for w in 0..<self[0][0][0].count {
                        result.append(HyperPoint(x, y, z, w))
                    }
                }
            }
        }
        return result
    }
}
