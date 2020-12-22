import Foundation

typealias GameResult = (winner: Int, winnerCards: [Int])

func calculateScore(_ gameResult: GameResult) -> Int {
    let cards = gameResult.winnerCards
    return cards.enumerated().reduce(0) { result, value in
        result + value.element * (cards.count - value.offset)
    }
}

func playCombat(_ cards: [[Int]], recursive: Bool = true) -> GameResult {
    var cards = cards
    var knownConfigs: Set<[[Int]]> = []
    var winner: Int?

    while winner == nil {
        if recursive {
            guard !knownConfigs.contains(cards) else { winner = 0; break }
            knownConfigs.insert(cards)
        }

        var topCards = [cards[0].removeFirst(), cards[1].removeFirst()]
        if recursive && cards[0].count >= topCards[0] && cards[1].count >= topCards[1] {
            let subCards = [
                Array(cards[0].prefix(topCards[0])),
                Array(cards[1].prefix(topCards[1]))
            ]
            let (subWinner, _) = playCombat(subCards)
            if subWinner == 1 { topCards.reverse() }
            cards[subWinner].append(contentsOf: topCards)
        } else {
            let winnerIdx = topCards[0] > topCards[1] ? 0 : 1
            cards[winnerIdx].append(contentsOf: topCards.sorted(by: >))
        }

        if cards[0].isEmpty { winner = 1 }
        if cards[1].isEmpty { winner = 0 }
    }

    return (winner!, cards[winner!])
}

var cards = [
    playerOneInput.components(separatedBy: "\n").compactMap(Int.init),
    playerTwoInput.components(separatedBy: "\n").compactMap(Int.init)
]

print("answer to part one: \(calculateScore(playCombat(cards, recursive: false)))") // 33694
print("answer to part two: \(calculateScore(playCombat(cards)))") // 31835
