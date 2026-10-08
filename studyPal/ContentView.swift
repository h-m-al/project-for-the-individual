import SwiftUI

struct ContentView: View {
    // 1. The data lives here now using standard @State variables
    @State private var userXP: Int = 0
    
    // 2. Pre-load the default data directly into the variable
    @State private var decks: [Deck] = [
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
                Flashcard(question: "What built-in structure handles concurrent communication?", answer: "Channel")
            ],
            icon: "server.rack"
        )
    ]
    
    var body: some View {
        TabView {
            // 3. Pass a reference ($) to the variables down to the child views
            DeckListView(decks: $decks, userXP: $userXP)
                .tabItem { Label("Study", systemImage: "rectangle.portrait.on.rectangle.portrait.angled") }
            
            CreateDeckView(decks: $decks)
                .tabItem { Label("Create", systemImage: "plus.circle.fill") }
            
            // Rewards only needs to read the XP, so we don't need a binding ($) here
            RewardsView(userXP: userXP)
                .tabItem { Label("Rewards", systemImage: "trophy.fill") }
        }
    }
}
