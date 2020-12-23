
import Foundation

struct FixedSizeBuffer {
    var buffer: [Int]
    private var currentIndex = 0

    init(_ values: [Int]) {
        buffer = values
    }

    func getNextThree() -> [Int] {
        [buffer[(currentIndex + 1) % buffer.count],
         buffer[(currentIndex + 2) % buffer.count],
         buffer[(currentIndex + 3) % buffer.count]
        ]
    }

    func findNextValue(moving: [Int]) -> Int {
        var candidate = buffer[currentIndex]
        repeat {
            if candidate == 1 {
                candidate = 9
            } else {
                candidate -= 1
            }
        } while moving.contains(candidate)
        return candidate
    }

    mutating func moveThree() {
        let moving = getNextThree()
        let destValue = findNextValue(moving: moving)

        var destIdx = (currentIndex + 1) % buffer.count
        var srcIdx = (currentIndex + 4) % buffer.count
        var movedDest = false
        while !movedDest {
            buffer[destIdx] = buffer[srcIdx]
            movedDest = buffer[destIdx] == destValue
            destIdx = (destIdx + 1) % buffer.count
            srcIdx = (srcIdx + 1) % buffer.count
        }
        for i in 0..<moving.count {
            buffer[(destIdx + i) % buffer.count] = moving[i]
        }
        currentIndex = (currentIndex + 1) % buffer.count
    }

    func printLabelValues() {
        let oneIdx = buffer.firstIndex(of: 1)!
        for i in 1..<buffer.count {
            print(buffer[(oneIdx + i) % buffer.count], terminator: "")
        }
    }
}

let input = "326519478"
//let input = "389125467" // test input

var values = FixedSizeBuffer(input.compactMap { Int(String($0)) })
for _ in 0..<100 {
    values.moveThree()
}

values.printLabelValues()
