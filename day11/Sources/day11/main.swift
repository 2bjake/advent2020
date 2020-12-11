enum Space {
    case floor, emptySeat, filledSeat
}

enum SeatingPreference {
    case adjacent, lineOfSight

    var maxNeighbors: Int { self == .adjacent ? 3 : 4 }
}

func determineNewSeating(_ spaces: [[Space]], withPreference preference: SeatingPreference) -> [[Space]] {
    var newSeats = spaces
    for point in spaces.allPoints where spaces[point] != .floor {
        let neighbors: [Space]
        if preference == .adjacent {
            neighbors = spaces.adjacentElements(of: point)
        } else {
            neighbors = spaces.lineOfSightElements(of: point) { $0 != .floor }
        }

        let filledCount = neighbors.count { $0 == .filledSeat }
        if filledCount == 0 {
            newSeats[point] = .filledSeat
        } else if filledCount > preference.maxNeighbors {
            newSeats[point] = .emptySeat
        }
    }
    return newSeats
}

func findStableFilledCount(in spaces: [[Space]], withPreference preference: SeatingPreference, maxIterations: Int = 1000) -> Int? {
    var spaces = spaces
    var previousCount = spaces.count { $0 == .filledSeat }
    for _ in 0..<maxIterations {
        spaces = determineNewSeating(spaces, withPreference: preference)
        let currentCount = spaces.count { $0 == .filledSeat }
        if currentCount == previousCount {
            return currentCount
        } else {
            previousCount = currentCount
        }
    }
    return nil
}

let spaces: [[Space]] = input.split(separator: "\n").map { row in
    row.map { $0 == "L" ? .emptySeat : .floor }
}

print("answer to part one: \(findStableFilledCount(in: spaces, withPreference: .adjacent)!)") // 2472
print("answer to part two: \(findStableFilledCount(in: spaces, withPreference: .lineOfSight)!)") // 2197
