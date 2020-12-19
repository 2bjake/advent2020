import Foundation

func findValidMessageCount(applyPatch: Bool) -> Int {
    let rulesById = buildRules(from: ruleData, applyPatch: applyPatch)
    let validator = Validator(rulesById: rulesById)
    let validMessages = messageData.split(separator: "\n").filter {
        validator.isValidMessage($0)
    }
    return validMessages.count

}

let partOne = findValidMessageCount(applyPatch: false)
print("answer to part one: \(partOne)") // 124

let partTwo = findValidMessageCount(applyPatch: true)
print("answer to part two: \(partTwo)") // 228
