//
//  Models.swift
//  studyPal
//
//  Created by Guest User on 08/10/2026.
//

import Foundation

// MARK: - Flashcard Model
/// Represents an individual flashcard containing a prompt question and answer.
/// Conforms to `Identifiable` so SwiftUI lists and loops can uniquely track each item.
struct Flashcard: Identifiable {
    let id = UUID()
    var question: String
    var answer: String
}

// MARK: - Deck Model
/// Represents a themed collection of flashcards.
struct Deck: Identifiable {
    let id = UUID()
    var title: String
    var cards: [Flashcard]
    var icon: String
}

// MARK: - Badge Model
/// Represents an unlockable achievement tied to the player's total XP.
struct Badge: Identifiable {
    let id = UUID()
    let name: String
    let requiredXP: Int
    let icon: String
}
