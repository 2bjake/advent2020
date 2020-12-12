typealias Instruction = (action: Action, value: Int)

let instructions: [Instruction] = input.split(separator: "\n").compactMap {
    guard let action = Action($0.first), let value = Int(String($0.dropFirst())) else {
        return nil
    }
    return (action, value)
}

func partOne() -> Int{
    var ship = Ship()
    ship.absoluteNavigate(instructions: instructions)
    return ship.distanceFromStart
}
print("answer to part one: \(partOne())") // 381

func partTwo() -> Int {
    var ship = Ship()
    ship.waypointNavigate(instructions: instructions)
    return ship.distanceFromStart
}
print("answer to part two: \(partTwo())") // 28591


