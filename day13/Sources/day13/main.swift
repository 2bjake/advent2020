import Foundation

let parts = input.components(separatedBy: "\n")
let time = Int(parts[0])!
let entries = parts[1].components(separatedBy: ",")

func partOne() {
    let busIds = entries.compactMap(Int.init)
    var bestBusId = busIds[0]
    var bestWait = busIds[0] - time % busIds[0]

    for busId in busIds {
        let curWait = busId - time % busId
        if curWait < bestWait {
            bestWait = curWait
            bestBusId = busId
        }
    }

    print(bestBusId * bestWait)
}

typealias Pair = (offset: Int, id: Int?)

func partTwo(start:Int, entries: [String]) {
    let incr = 937 * 17 * 23 * 29 * 37
    var cur = start / incr * incr

    while true {
        if (cur + 31) % 397 == 0 &&
            (cur - 10) % 41 == 0 &&
            (cur + 50) % 19 == 0 &&
            (cur + 18) % 13 == 0 {
            break
        }
        cur += incr
    }
    print(cur - 17)
}

partTwo(start: 100_000_000_000_000, entries: entries)
