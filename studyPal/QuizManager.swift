//
//  Untitled.swift
//  studyPal
//
//  Created by Guest User on 08/10/2026.
//

import SwiftUI
public import Combine

// MARK: - Quiz Manager (State Engine)
/// `QuizManager` uses the `ObservableObject` protocol to broadcast state changes across all views.
/// Any view observing this object will automatically refresh when `@Published` properties change.
class QuizManager: ObservableObject {
    
    // MARK: - Published Properties
    /// Stores the active list of flashcard decks.
    @Published var decks: [Deck] = []
    
    /// Tracks total Experience Points (XP) earned by the user across quiz sessions.
    @Published var userXP: Int = 0
    
    // MARK: - Initializer
    init() {
        // Automatically populates the app with pre-built decks upon launch
        loadDefaultData()
    }
    
    // MARK: - Core Business Logic
    
    /// Adds earned XP from completing cards/decks to the user profile.
    /// - Parameter amount: Number of points earned.
    func addXP(_ amount: Int) {
        userXP += amount
    }
    
    /// Appends a newly created user deck to the global list.
    func addDeck(title: String, cards: [Flashcard], icon: String) {
        let newDeck = Deck(title: title, cards: cards, icon: icon)
        decks.append(newDeck)
    }
    
    // MARK: - Default Test Data Generator
    /// Pre-populates default decks to test app functionality immediately without manual entry.
    private func loadDefaultData() {
        decks = [
            Deck(
                title: "Deadlock Matchups",
                cards: [
                    Flashcard(question: "Which hero relies most on vertical lane mobility?", answer: "Vindicta"),
                    Flashcard(question: "What is the optimal counter-item for an aggressive Seven?", answer: "Knockdown"),
                    Flashcard(question: "Which lane strategy maximizes early soul economy?", answer: "Denying enemy souls")
                ],
                icon: "gamecontroller.fill"
            ),
            Deck(
                title: "Go Backend Basics",
                cards: [
                    Flashcard(question: "Which keyword executes a function concurrently in Go?", answer: "go"),
                    Flashcard(question: "What built-in structure handles concurrent communication?", answer: "Channel"),
                    Flashcard(question: "Which package provides HTTP server implementations?", answer: "net/http")
                ],
                icon: "server.rack"
            ),
            Deck(
                title: "SwiftUI Fundamentals",
                cards: [
                    Flashcard(question: "Which property wrapper manages local view state?", answer: "@State"),
                    Flashcard(question: "Which layout container stacks child views vertically?", answer: "VStack")
                ],
                icon: "swift"
            )
        ]
    }
}
