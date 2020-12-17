import Foundation

let initialValues = input.split(separator: "\n").map { row in
    row.map { $0 == "#" }
}

let iterations = 6

func buildGrid() -> [[[Bool]]] {
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
    return grid
}

func buildHyperGrid() -> [[[[Bool]]]] {
    let height = initialValues.count + 2 * iterations
    let width = initialValues[0].count + 2 * iterations
    let depth = 1 + 2 * iterations

    let wRow = Array(repeating: false, count: depth)
    let zRow = Array(repeating: wRow, count: depth)
    let xRow = Array(repeating: zRow, count: width)
    var grid = Array(repeating: xRow, count: height)

    for y in 0..<initialValues.count {
        for x in 0..<initialValues[0].count {
            grid[HyperPoint(x + iterations, y + iterations, iterations, iterations)] = initialValues[y][x]
        }
    }
    return grid
}

func determineNewGrid(_ grid: [[[Bool]]]) -> [[[Bool]]] {
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

func partOne() {
    var grid = buildGrid()
    for _ in 0..<6 {
        grid = determineNewGrid(grid)
    }

    let count = grid.allPoints.reduce(0) { result, value in
        grid[value] ? result + 1 : result
    }

    print(count) // 315
}
partOne()


func determineNewHyperGrid(_ grid: [[[[Bool]]]]) -> [[[[Bool]]]] {
    var newGrid = grid
    for point in grid.allHyperPoints {
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

func partTwo() {
    var grid = buildHyperGrid()
    for _ in 0..<6 {
        grid = determineNewHyperGrid(grid)
    }

    let count = grid.allHyperPoints.reduce(0) { result, value in
        grid[value] ? result + 1 : result
    }

    print(count) // 1520
}
partTwo()
