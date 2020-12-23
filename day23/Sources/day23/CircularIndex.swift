//
//  CircleIndex.swift
//
//
//  Created by Jake Foster on 12/23/20.
//

struct CircularIndex {
    let value: Int
    let count: Int

    init(_ initial: Int, count: Int) {
        self.value = initial % count
        self.count = count
    }
}

func +(idx: CircularIndex, value: Int) -> CircularIndex {
    CircularIndex((idx.value + value) % idx.count, count: idx.count)
}

func +=(idx: inout CircularIndex, value: Int) {
    idx = idx + value
}

extension RandomAccessCollection where Index == Int {
    subscript(_ idx: CircularIndex) -> Element {
        get { self[idx.value] }
    }

    subscript(_ idx: CircularIndex) -> Element where Self: MutableCollection {
        get { self[idx.value] }
        set { self[idx.value] = newValue }
    }
}


