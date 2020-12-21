//
//  MonsterHunter.swift
//
//
//  Created by Jake Foster on 12/20/20.
//

import Foundation

struct MonsterHunter {
    var photo: [[Character]]

    private static let patternIdx = [
        [18],
        [0, 5, 6, 11, 12, 17, 18, 19],
        [1, 4, 7, 10, 13, 16]
    ]

    private static var monsterSize: Int { patternIdx.flatMap { $0 }.count }

    private static func processTiles(_ tiles: [[Tile]]) -> [[Character]] {
        let tileSize = tiles[0][0].data.count - 2

        var result = [[Character]]()
        for row in tiles {
            for i in 0..<tileSize {
                var line = [Character]()
                for tile in row {
                    line.append(contentsOf: tile.dataWithoutBorder[i])
                }
                result.append(line)
            }
        }
        return result
    }

    init(tiles: [[Tile]]) {
        photo = Self.processTiles(tiles)
    }

    func printPhoto() {
        for line in photo {
            print(String(line))
        }
    }

    func countMonsterTailTipsInRow(_ rowIdx: Int) -> Int {
        var count = 0
        for i in 0..<(photo.count - 19) {
            if Self.patternIdx[1].allSatisfy({ photo[rowIdx][i + $0] == "#" }) &&
                Self.patternIdx[2].allSatisfy({ photo[rowIdx + 1][i + $0] == "#" }) &&
                Self.patternIdx[0].allSatisfy({ photo[rowIdx - 1][i + $0] == "#" }) {
                count += 1
            }
        }
        return count
    }

    func analyzePhoto() -> (monsterCount: Int, roughnessCount: Int) {
        var monsterCount = 0
        for i in 1..<(photo.count - 1) {
            monsterCount += countMonsterTailTipsInRow(i)
        }

        let roughnessCount = photo.flatMap { $0 }.filter { $0 == "#" }.count - monsterCount * Self.monsterSize

        return (monsterCount, roughnessCount)
    }
}
