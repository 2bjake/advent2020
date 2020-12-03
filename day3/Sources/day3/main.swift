let grid = input.split(separator: "\n").map { line in
    line.map { $0 }
}

typealias Slope = (right: Int, down: Int)

func countTreesOnSlope(_ slope: Slope) -> Int {
    var treeCount = 0

    let height = grid.count
    let width = grid[0].count

    var x = 0
    var y = 0
    while y < height {
        if grid[y][x] == "#" {
            treeCount += 1
        }
        x = (x + slope.right) % width
        y += slope.down
    }
    return treeCount
}

func partOne() -> Int {
    let slope = (3, 1)
    return countTreesOnSlope(slope)
}

func partTwo() -> Int {
    let slopes = [
        (1, 1),
        (3, 1),
        (5, 1),
        (7, 1),
        (1, 2)
    ]

    return slopes.map(countTreesOnSlope).reduce(1, *)
}

print("The answer for part one: \(partOne())")
print("The answer for part two: \(partTwo())")
