import SwiftUI

struct CreateDeckView: View {
    // Allows this view to add new decks to the main array
    @Binding var decks: [Deck]
    
    @State private var deckTitle = ""
    @State private var draftedCards: [Flashcard] = []
    @State private var questionInput = ""
    @State private var answerInput = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Deck Title")) {
                    TextField("e.g., Computer Architecture", text: $deckTitle)
                }
                
                Section(header: Text("Add Flashcard")) {
                    TextField("Enter Question", text: $questionInput)
                    TextField("Enter Answer", text: $answerInput)
                    
                    Button(action: addCardToDraft) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Card to Draft")
                        }
                        .foregroundColor(.blue)
                    }
                    .disabled(questionInput.isEmpty || answerInput.isEmpty)
                }
                
                if !draftedCards.isEmpty {
                    Section(header: Text("Drafted Cards (\(draftedCards.count))")) {
                        ForEach(draftedCards) { card in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Q: \(card.question)").font(.subheadline).bold()
                                Text("A: \(card.answer)").font(.caption).foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section {
                    Button(action: saveCompleteDeck) {
                        Text("Save Deck to Library")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(draftedCards.isEmpty ? .gray : .green)
                    }
                    .disabled(draftedCards.isEmpty)
                }
            }
            .navigationTitle("Create Deck")
        }
    }
    
    private func addCardToDraft() {
        let card = Flashcard(question: questionInput, answer: answerInput)
        draftedCards.append(card)
        questionInput = ""
        answerInput = ""
    }
    
    private func saveCompleteDeck() {
        let title = deckTitle.isEmpty ? "Untitled Deck" : deckTitle
        let newDeck = Deck(title: title, cards: draftedCards, icon: "folder.fill")
        
        // Append directly to the bound array
        decks.append(newDeck)
        
        deckTitle = ""
        draftedCards.removeAll()
    }
}
