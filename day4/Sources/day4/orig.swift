//
//  old.swift
//  
//
//  Created by Jake Foster on 12/4/20.
//

func isValidPartTwoFieldsOrig(_ fields: [String: String]) -> Bool {
    func isValidYear(at field: String, within range: ClosedRange<Int>) -> Bool {
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
        return validEyeColors.contains(color)
    }

    func isPassportIdValid() -> Bool {
        guard let id = fields["pid"] else { return false }
        return id.count == 9 && Int(id) != nil
    }

    return isValidYear(at: "byr", within: 1920...2002) &&
        isValidYear(at: "iyr", within: 2010...2020) &&
        isValidYear(at: "eyr", within: 2020...2030) &&
        isHeightValid() &&
        isHairColorValid() &&
        isEyeColorValid() &&
        isPassportIdValid()
}

