
import Foundation

let input = "326519478"
//let input = "389125467" // test input

func partOne() {
    let values = input.compactMap { Int(String($0)) }
    var buffer = CircularBuffer(values)
    for _ in 0..<100 {
        buffer.move(3)
    }
    let labels = buffer.getNext(values.count - 1, after: 1).map(String.init).joined(separator: "")
    print("answer to part one: \(labels)") // 25368479
}
partOne()

func partTwo() {
    let values = input.compactMap { Int(String($0)) }
    var buffer = OptimizedCircularBuffer(values, fillingTo: 1_000_000)
    for i in 0..<10_000_000 {
        //print(i)
        buffer.move(3)
    }
    let product = buffer.getNext(2, after: 1).reduce(1, *)
    print("answer to part two: \(product)")
}
partTwo()


//func copyMemory<T>(in bufferPointer: UnsafeMutableBufferPointer<T>, from sourceIndicies: ClosedRange<Int>, to destinationIndex: Int) {
//    let size = MemoryLayout<T>.size
//    let frontPointer = UnsafeMutableRawPointer(bufferPointer.baseAddress!)
//    let sourcePointer = frontPointer + sourceIndicies.lowerBound * size
//    let sourceLength = sourceIndicies.count * size
//    let destinationPointer = frontPointer + destinationIndex * size
//    destinationPointer.copyMemory(from: sourcePointer, byteCount: sourceLength)
//}
//
//var a = ContiguousArray(repeating: 0, count: 20)
//for i in 0..<a.count { a[i] = i }
//print(a)
//let count = a.count
//a.withUnsafeMutableBufferPointer {
//    copyMemory(in: $0, from: (2...count-1), to: 0)
//}
//print(a)
