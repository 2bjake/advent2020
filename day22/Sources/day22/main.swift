import Foundation

func calculateScore(_ cards: [Int]) -> Int {
    cards.enumerated().reduce(0) { result, value in
        result + value.element * (cards.count - value.offset)
    }
}

func playCombat(_ cards: [[Int]]) -> [Int] {
    var cards = cards
    while !cards[0].isEmpty && !cards[1].isEmpty {
        let topCards = [cards[0].removeFirst(), cards[1].removeFirst()]
        let winnerIdx = topCards[0] > topCards[1] ? 0 : 1
        cards[winnerIdx].append(contentsOf: topCards.sorted(by: >))
    }

    return cards[0].isEmpty ? cards[1] : cards[0]
}

func playRecursiveCombat(_ cards: [[Int]]) -> (winner: Int, cards: [Int]) {
    var cards = cards
    var knownConfigs: Set<[[Int]]> = []
    var winner: Int?

    while winner == nil {
        guard !knownConfigs.contains(cards) else {
            winner = 0
            break
        }

        knownConfigs.insert(cards)
        var topCards = [cards[0].removeFirst(), cards[1].removeFirst()]
        if cards[0].count >= topCards[0] && cards[1].count >= topCards[1] {
            let subCards = [
                Array(cards[0].prefix(topCards[0])),
                Array(cards[1].prefix(topCards[1]))
            ]
            let (subWinner, _) = playRecursiveCombat(subCards)
            cards[subWinner].append(topCards.remove(at: subWinner))
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

let partOneScore = calculateScore(playCombat(cards))
print("answer to part one: \(partOneScore)") // 33694


let example = [[9, 2, 6, 3, 1], [5, 8, 4, 7, 10]]
let result = playRecursiveCombat(cards)
print(calculateScore(result.cards))
