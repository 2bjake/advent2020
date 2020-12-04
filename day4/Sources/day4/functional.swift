//
//  functional.swift
//  
//
//  Created by Jake Foster on 12/4/20.
//

import Foundation

typealias Validator = (String) -> Bool

func makeYearValidator(with range: ClosedRange<Int>) -> Validator {
    return { year in
        return isYear(year, within: range)
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
