import Foundation

extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
    }
}

// part 1
let requiredFields: Set<String> = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

func hasRequiredFields(_ fields: [String: String]) -> Bool {
    return requiredFields.isSubset(of: fields.keys)
}

// part 2

func isValidYear(_ year: String, within range: ClosedRange<Int>) -> Bool {
    return range.contains(Int(year) ?? -1)
}

func isValidHeight(_ height: String) -> Bool {
    guard let value = Int(height.dropLast(2)) else { return false }

    switch height.suffix(2) {
        case "in": return (59...76).contains(value)
        case "cm": return (150...193).contains(value)
        default: return false
    }
}

func isValidHairColor(_ color: String) -> Bool {
    return color.count == 7 && color.first == "#" && Int(color.dropFirst(), radix: 16) != nil
}

let validEyeColors: Set<String> = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
func isValidEyeColor(_ color: String) -> Bool {
    return validEyeColors.contains(color)
}

func isValidPassportId(_ id: String) -> Bool {
    return id.count == 9 && Int(id) != nil
}

func hasValidFields(_ fields: [String: String]) -> Bool {
    guard hasRequiredFields(fields) else { return false }
    for field in fields {
        switch field.key {
            case "byr": guard isValidYear(field.value, within: 1920...2002) else { return false }
            case "iyr": guard isValidYear(field.value, within: 2010...2020) else { return false }
            case "eyr": guard isValidYear(field.value, within: 2020...2030) else { return false }
            case "hgt": guard isValidHeight(field.value) else { return false }
            case "hcl": guard isValidHairColor(field.value) else { return false }
            case "ecl": guard isValidEyeColor(field.value) else { return false }
            case "pid": guard isValidPassportId(field.value) else { return false }
            default: break
        }
    }
    return true
}

//// Functional version /////

typealias Validator = (String) -> Bool

func makeYearValidator(with range: ClosedRange<Int>) -> Validator {
    return { year in
        return isValidYear(year, within: range)
    }
}

let validators = [
    "byr": makeYearValidator(with: 1920...2002),
    "iyr": makeYearValidator(with: 2010...2020),
    "eyr": makeYearValidator(with: 2020...2030),
    "hgt": isValidHeight,
    "hcl": isValidHairColor,
    "ecl": isValidEyeColor,
    "pid": isValidPassportId
]

func hasValidFieldsFunctional(_ fields: [String: String]) -> Bool {
    guard hasRequiredFields(fields) else { return false }
    return fields.allSatisfy { key, value in
        validators[key]?(value) ?? true
    }
}

/////////////////////////////

// main
func buildDocument(_ str: String) -> [String: String] {
    str.components(separatedBy: .whitespacesAndNewlines).reduce(into: [:]) { result, field in
        let parts = field.components(separatedBy: ":")
        result[parts[0]] = parts[1]
    }
}

let docs = input.components(separatedBy: "\n\n").map(buildDocument)

let partOneValidCount = docs.count(where: hasRequiredFields)
print("Answer to part one: \(partOneValidCount)")

let partTwoValidCount = docs.count(where: hasValidFieldsFunctional)
print("Answer to part two: \(partTwoValidCount)")
