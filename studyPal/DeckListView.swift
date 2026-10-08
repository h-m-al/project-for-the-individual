import SwiftUI

struct DeckListView: View {
    @Binding var decks: [Deck]
    @Binding var userXP: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                // Subtle gradient background
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(decks) { deck in
                            NavigationLink(destination: QuizView(deck: deck, userXP: $userXP)) {
                                HStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: deck.icon)
                                            .foregroundColor(.white)
                                            .font(.title3)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(deck.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text("\(deck.cards.count) Flashcards")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Study Decks")
        }
    }
}
