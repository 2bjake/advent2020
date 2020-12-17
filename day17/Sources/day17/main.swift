import Foundation

let initialValues = input.split(separator: "\n").map { row in
    row.map { $0 == "#" }
}

let iterations = 6

let height = initialValues.count + 2 * iterations
let width = initialValues[0].count + 2 * iterations
let depth = 1 + 2 * iterations

let zRow = Array(repeating: false, count: depth)
let xRow = Array(repeating: zRow, count: width)
var grid = Array(repeating: xRow, count: height)

for y in 0..<initialValues.count {
    for x in 0..<initialValues[0].count {
        grid[Point(x + iterations, y + iterations, iterations)] = initialValues[y][x]
    }
}

func determineNewGrid(_ cubes: [[[Bool]]]) -> [[[Bool]]] {
    var newGrid = grid
    for point in grid.allPoints {
        let neighbors = grid.adjacentElements(of: point)
        let activeCount = neighbors.count { $0 }

        if grid[point] && (activeCount != 2 && activeCount != 3) {
            newGrid[point] = false
        } else if !grid[point] && activeCount == 3 {
            newGrid[point] = true
        }

    }
    return newGrid
}

for _ in 0..<6 {
    grid = determineNewGrid(grid)
}

let count = grid.allPoints.reduce(0) { result, value in
    grid[value] ? result + 1 : result
}

print(count)
