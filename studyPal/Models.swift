import Foundation

struct Flashcard: Identifiable {
    let id = UUID()
    var question: String
    var answer: String
}

struct Deck: Identifiable {
    let id = UUID()
    var title: String
    var cards: [Flashcard]
    var icon: String
}

struct Badge: Identifiable {
    let id = UUID()
    let name: String
    let requiredXP: Int
    let icon: String
}
