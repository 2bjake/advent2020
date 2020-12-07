//
//  Regex+extensions.swift
//  
//
//  Created by Jake Foster on 12/7/20.
//

import Regex

enum Group: String {
    case count, color, contents
}

extension Match {
    func group<G: RawRepresentable>(_ name: G) -> String? where G.RawValue == String {
        group(named: name.rawValue)
    }

    func group(_ name: Group) -> String? {
        group(named: name.rawValue)
    }
}

extension Regex {
    convenience init<G: RawRepresentable>(pattern: String, groups: G...) throws where G.RawValue == String {
        try self.init(pattern: pattern, groupNames: groups.map(\.rawValue))
    }

    convenience init(pattern: String, groups: Group...) throws {
        try self.init(pattern: pattern, groupNames: groups.map(\.rawValue))
    }
}
