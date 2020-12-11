typealias Point = (x: Int, y: Int)

extension Array {
    subscript<T>(_ point: Point) -> T where Element == Array<T> {
        get { self[point.y][point.x] }
        set { self[point.y][point.x] = newValue }
    }
}

func calculateNeighbors<T>(of point: Point, clampedBy grid: [[T]]) -> [Point] {
    var neighbors = [Point]()
    for x in -1...1 {
        for y in -1...1 {
            let newPoint = Point(x: point.x + x, y: point.y + y)
            if newPoint != point && grid.indices.contains(newPoint.y) && grid[0].indices.contains(newPoint.x) {
                neighbors.append(newPoint)
            }
        }
    }
    return neighbors
}

typealias Seats = [[Bool?]]


func countOccupiedSeats(_ seats: [Bool?]) -> Int {
    seats.filter { $0 == true }.count
}
func countOccupiedSeats(_ seats: Seats) -> Int {
    countOccupiedSeats(seats.flatMap { $0 })
}

func determineNewSeating(_ seats: Seats) -> Seats {
    var newSeats = seats
    for x in 0..<seats[0].count {
        for y in 0..<seats.count {
            let point = Point(x, y)
            if seats[point] != nil {
                let neighbors = calculateNeighbors(of: point, clampedBy: seats).map { seats[$0] }
                let occupiedNeighbors = countOccupiedSeats(neighbors)
                if occupiedNeighbors == 0 {
                    newSeats[point] = true
                } else if occupiedNeighbors >= 4 {
                    newSeats[point] = false
                }
            }
        }
    }
    return newSeats
}

var seats = input.split(separator: "\n").map { row in
    row.map { $0 == "L" ? false : nil }
}

var lastCount = countOccupiedSeats(seats)
for _ in 0..<1000 {
    seats = determineNewSeating(seats)
    let newCount = countOccupiedSeats(seats)
    if newCount == lastCount {
        break
    } else {
        lastCount = newCount
    }
}

print(lastCount)
