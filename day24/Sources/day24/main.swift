
enum Direction: String, CaseIterable {
    case east = "e"
    case southeast = "se"
    case southwest = "sw"
    case west = "w"
    case northwest = "nw"
    case northeast = "ne"
}

struct Coordinates: Hashable {
    var x: Int
    var y: Int
}

extension Coordinates {
    static let origin = Coordinates(x: 0, y: 0)

    var allNeighbors: [Coordinates] {
        Direction.allCases.map { newCoordinates(heading: $0) }
    }

    func newCoordinates(heading direction: Direction) -> Coordinates {
        switch direction {
            case .west:      return Coordinates(x: x - 1, y: y + 0)
            case .east:      return Coordinates(x: x + 1, y: y + 0)
            case .northwest: return Coordinates(x: x - 1, y: y + 1)
            case .northeast: return Coordinates(x: x + 0, y: y + 1)
            case .southwest: return Coordinates(x: x + 0, y: y - 1)
            case .southeast: return Coordinates(x: x + 1, y: y - 1)
        }
    }
}

enum Color { case white, black }

struct Tile {
    var coordinates: Coordinates
    var color: Color = .white
}

extension Tile {
    func flipped() -> Tile {
        Tile(coordinates: coordinates, color: color == .black ? .white : .black)
    }
}

func removeFirstDirection(in array: inout [Character]) -> Direction {
    let first = array.removeFirst()
    if let direction = Direction(rawValue: String(first)) {
        return direction
    }
    let second = array.removeFirst()
    return Direction(rawValue: "\(first)\(second)")!
}

var tilesByCoords = [Coordinates.origin: Tile(coordinates: .origin)]

func processLine(_ line: [Character]) {
    var line = line
    var currentCoords = Coordinates.origin
    while !line.isEmpty {
        let direction = removeFirstDirection(in: &line)
        let newCoords = currentCoords.newCoordinates(heading: direction)
        if tilesByCoords[newCoords] == nil {
            tilesByCoords[newCoords] = Tile(coordinates: newCoords)
        }
        currentCoords = newCoords
    }
    tilesByCoords[currentCoords] = tilesByCoords[currentCoords]?.flipped()
}

input.split(separator: "\n").map(Array.init).forEach(processLine)

func countBlackTiles() -> Int {
    tilesByCoords.values.filter { $0.color == .black }.count
}

func partOne() {
    print("answer to part one: \(countBlackTiles())") // 411
}
partOne()

func flipTiles() {
    var newTiles = tilesByCoords
    for (coords, tile) in tilesByCoords {
        let neighbors = coords.allNeighbors.compactMap { tilesByCoords[$0] }
        let blackCount = neighbors.filter { $0.color == .black }.count

        let shouldFlip =
            (tile.color == .black && (blackCount == 0 || blackCount > 2)) ||
            (tile.color == .white && blackCount == 2)

        if shouldFlip { newTiles[coords] = tile.flipped() }
    }
    tilesByCoords = newTiles
}

func fillEdges() {
    let allCoords = Set(tilesByCoords.keys.flatMap(\.allNeighbors))
    for coords in allCoords where tilesByCoords[coords] == nil {
        tilesByCoords[coords] = Tile(coordinates: coords)
    }
}

func partTwo() {
    for _ in 0..<100 {
        fillEdges()
        flipTiles()
    }
    print("answer to part two: \(countBlackTiles())") // 4092
}
partTwo()
