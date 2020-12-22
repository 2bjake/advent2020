import Foundation

var cards = [
    playerOneInput.components(separatedBy: "\n").compactMap(Int.init),
    playerTwoInput.components(separatedBy: "\n").compactMap(Int.init)
]

while !cards[0].isEmpty && !cards[1].isEmpty {
    let topCards = [cards[0].removeFirst(), cards[1].removeFirst()]
    let winnerIdx = topCards[0] > topCards[1] ? 0 : 1
    cards[winnerIdx].append(contentsOf: topCards.sorted(by: >))
}

let winner = cards[0].isEmpty ? cards[1] : cards[0]

var score = 0
for i in 0..<winner.count {
    score += winner[i] * (winner.count - i)
}
print(score)
