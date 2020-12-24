
enum Direction: String {
    case east = "e"
    case southeast = "se"
    case southwest = "sw"
    case west = "w"
    case northwest = "nw"
    case northeast = "ne"
}

enum Color { case white, black }

struct Point: Hashable {
    var x: Int
    var y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    static let origin = Point(0, 0)
}

// (0, 0) -> west -> (-1, 0)
// (0, 0) -> east -> (1, 0)
// (0, 0) -> northwest -> (-1, 1)
// (0, 0) -> northeast -> (0, 1)
// (0, 0) -> southwest -> (0, -1)
// (0, 0) -> southeast -> (1, -1)

extension Point {
    func newPoint(in direction: Direction) -> Point {
        switch direction {
            case .west:      return Point(x - 1, y + 0)
            case .east:      return Point(x + 1, y + 0)
            case .northwest: return Point(x - 1, y + 1)
            case .northeast: return Point(x + 0, y + 1)
            case .southwest: return Point(x + 0, y - 1)
            case .southeast: return Point(x + 1, y - 1)
        }
    }
}

class Tile {
    var color: Color = .white
    var neighbors: [Direction: Tile] = [:]
    var coordinates: Point

    init(coordinates: Point) {
        self.coordinates = coordinates
    }
}

extension Tile {
    func flip() {
        switch color {
            case .white: color = .black
            case .black: color = .white
        }
    }
}

var startTile = Tile(coordinates: .origin)
var tilesByCoords = [Point.origin: startTile]

func removeFirstDirection(in array: inout [Character]) -> Direction {
    let first = array.removeFirst()
    if let direction = Direction(rawValue: String(first)) {
        return direction
    } else {
        let second = array.removeFirst()
        return Direction(rawValue: "\(first)\(second)")!
    }
}

func processLine(_ line: [Character]) {
    var line = line
    var currentTile = startTile
    while !line.isEmpty {
        let direction = removeFirstDirection(in: &line)
        if currentTile.neighbors[direction] == nil {
            let newPoint = currentTile.coordinates.newPoint(in: direction)
            let newTile = tilesByCoords[newPoint, default: Tile(coordinates: newPoint)]
            currentTile.neighbors[direction] = newTile
            tilesByCoords[newPoint] = newTile
        }
        currentTile = currentTile.neighbors[direction]!
    }
    currentTile.flip()
}

input.split(separator: "\n").map(Array.init).forEach(processLine)

let count = tilesByCoords.values.filter { $0.color == .black }.count
print(count)
