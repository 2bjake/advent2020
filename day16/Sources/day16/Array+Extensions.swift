//
//  Array+Extensions.swift
//
//
//  Created by Jake Foster on 12/16/20.
//

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    func buildColumn(at idx: Index) -> [Element.Element] {
        (0..<count).map { self[$0][idx] }
    }

    func buildColumns() -> [[Element.Element]] {
        guard !isEmpty else { return [[]] }
        return (0..<self[0].count).map(buildColumn)
    }
}
