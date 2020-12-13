import Foundation

func partOne() {
    let parts = input.components(separatedBy: "\n")
    let time = Int(parts[0])!
    let busIds = parts[1].components(separatedBy: ",").compactMap(Int.init)

    let best = busIds
        .map { (id: $0, wait: $0 - time % $0) }
        .min { $0.wait < $1.wait }

    print(best!.id * best!.wait)
}
partOne()

func partTwo() {
    let incr = 937 * 17 * 23 * 29 * 37
    var cur = 100_000_000_000_000 / incr * incr

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

partTwo()
