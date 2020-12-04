import Foundation

extension Sequence {
    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
    }
}

let requiredFields: Set<String> = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

func isValidPartOneDoc(_ doc: String) -> Bool {
    let fields = doc.components(separatedBy: .whitespacesAndNewlines).compactMap {
        $0.components(separatedBy: ":").first
    }
    return requiredFields.isSubset(of: fields)
}

func isValidPartTwoDoc(_ doc: String) -> Bool {
    let fields: [String: String] = doc.components(separatedBy: .whitespacesAndNewlines).reduce(into: [:]) { result, field in
        let parts = field.components(separatedBy: ":")
        result[parts[0]] = parts[1]
    }

    func isYear(at field: String, within range: ClosedRange<Int>) -> Bool {
        guard let year = Int(fields[field, default: ""]) else { return false }
        return range.contains(year)
    }

    func isHeightValid() -> Bool {
        guard let height = fields["hgt"] else { return false }
        guard let value = Int(height.dropLast(2)) else { return false }

        switch height.suffix(2) {
            case "in": return (59...76).contains(value)
            case "cm": return (150...193).contains(value)
            default: return false
        }
    }

    func isHairColorValid() -> Bool {
        guard let color = fields["hcl"] else { return false }
        return color.first == "#" && Int(color.dropFirst(), radix: 16) != nil
    }

    func isEyeColorValid() -> Bool {
        guard let color = fields["ecl"] else { return false }
        return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(color)
    }

    func isPassportIdValid() -> Bool {
        guard let id = fields["pid"] else { return false }
        return id.count == 9 && Int(id) != nil
    }

    return isYear(at: "byr", within: 1920...2002) &&
        isYear(at: "iyr", within: 2010...2020) &&
        isYear(at: "eyr", within: 2020...2030) &&
        isHeightValid() &&
        isHairColorValid() &&
        isEyeColorValid() &&
        isPassportIdValid()
}

let docs = input.components(separatedBy: "\n\n")

let partOneValidCount = docs.count(where: isValidPartOneDoc)
print("Answer to part one: \(partOneValidCount)")

let partTwoValidCount = docs.count(where: isValidPartTwoDoc)
print("Answer to part two: \(partTwoValidCount)")
