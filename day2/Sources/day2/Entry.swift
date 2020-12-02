//
//  Entry.swift
//  
//
//  Created by Jake Foster on 12/2/20.
//

import Foundation

struct Entry {
    let firstInt: Int
    let secondInt: Int
    let character: Character
    let password: String
}

// extension for part 1
extension Entry {
    private var occuranceRange: ClosedRange<Int> {
        firstInt...secondInt
    }

    var isValidForPartOne: Bool {
        let count = password.filter { $0 == character }.count
        return occuranceRange.contains(count)
    }
}

// extension for part 2
extension Entry {
    private var firstPosition: Int {
        firstInt - 1
    }

    private var secondPosition: Int {
        secondInt - 1
    }

    var isValidForPartTwo: Bool {
        let firstChar = password.dropFirst(firstPosition).first
        let secondChar = password.dropFirst(secondPosition).first

        return (firstChar == character || secondChar == character) && firstChar != secondChar
    }
}

// string parse init
extension Entry {
    init?<S: StringProtocol>(_ str: S) {
        guard let entry = splitEntryBuilder(str) else {
            return nil
        }
        self = entry
    }
}

private func splitEntryBuilder<S: StringProtocol>(_ str: S) -> Entry? {
    let groups = str.split(separator: " ")
    guard groups.count == 3 else { return nil }

    let numbers = groups[0].split(separator: "-").compactMap { Int($0) }
    guard numbers.count == 2 else { return nil }

    guard let character = groups[1].first else { return nil }

    let password = String(groups[2])

    return Entry(firstInt: numbers[0], secondInt: numbers[1], character: character, password: password)
}

private func regexEntryBuilder(_ str: String) -> Entry? {
    let pattern = #"(\d+)-(\d+) ([a-z]): (.*)"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    var entry: Entry?

    let nsrange = NSRange(str.startIndex..<str.endIndex,
                          in: str)
    regex.enumerateMatches(in: str,
                           options: [],
                           range: nsrange) { (match, _, stop) in
        guard let match = match else { return }

        if let firstCaptureRange = Range(match.range(at: 1),
                                         in: str),
           let secondCaptureRange = Range(match.range(at: 2),
                                          in: str),
           let thirdCaptureRange = Range(match.range(at: 3),
                                          in: str),
           let fourthCaptureRange = Range(match.range(at: 4),
                                          in: str),
           let firstInt = Int(str[firstCaptureRange]),
           let secondInt = Int(str[secondCaptureRange]),
           str[thirdCaptureRange].count == 1,
           let character = str[thirdCaptureRange].first
        {
            entry = Entry(firstInt: firstInt, secondInt: secondInt, character: character, password: String(str[fourthCaptureRange]))
            stop.pointee = true
        }
    }
    return entry
}
