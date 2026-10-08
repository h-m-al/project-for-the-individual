import SwiftUI

struct QuizView: View {
    let deck: Deck
    
    @Binding var userXP: Int
    
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var sessionXP = 0
    @State private var isFinished = false
    
    // Animation States
    @State private var cardRotation = 0.0
    @State private var showFloatingXP = false
    @State private var floatingXPAmount = 0
    @State private var floatingXPOffset: CGFloat = 0
    @State private var floatingXPOpacity = 0.0
    @State private var cardScale = 1.0
    
    var body: some View {
        ZStack {
            // Modern Vibrant Background
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.4), Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                if isFinished {
                    completionScreen
                } else if deck.cards.isEmpty {
                    Text("This deck contains no flashcards.")
                        .foregroundColor(.secondary)
                } else {
                    ProgressView(value: Double(currentIndex), total: Double(deck.cards.count))
                        .tint(.purple)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    // The 3D Animated Card
                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .fill(Color(uiColor: .systemBackground).opacity(0.9))
                            .shadow(color: Color.purple.opacity(0.3), radius: 20, x: 0, y: 10)
                        
                        // We rotate the text inside backward when flipped, so it doesn't read backward!
                        Text(isFlipped ? deck.cards[currentIndex].answer : deck.cards[currentIndex].question)
                            .font(.title2)
                            .fontWeight(isFlipped ? .medium : .bold)
                            .multilineTextAlignment(.center)
                            .padding()
                            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(height: 350)
                    .padding(.horizontal, 20)
                    .scaleEffect(cardScale)
                    .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        flipCard()
                    }
                    .overlay(
                        // The Prominent Floating XP Animation
                        Text("+\(floatingXPAmount) XP")
                            .font(.largeTitle.bold())
                            .foregroundColor(.green)
                            .shadow(color: .black.opacity(0.2), radius: 5)
                            .opacity(floatingXPOpacity)
                            .offset(y: floatingXPOffset)
                    )
                    
                    Text(isFlipped ? "How well did you know this?" : "Tap the card to reveal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                    
                    // The 4 Broader Options (Spaced Repetition Style)
                    if isFlipped {
                        HStack(spacing: 12) {
                            actionButton(title: "Again", icon: "arrow.counterclockwise", color: .red, xp: 0)
                            actionButton(title: "Hard", icon: "brain", color: .orange, xp: 5)
                            actionButton(title: "Good", icon: "hand.thumbsup.fill", color: .blue, xp: 10)
                            actionButton(title: "Easy", icon: "bolt.fill", color: .green, xp: 15)
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationTitle(deck.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Reusable Modern Action Button
    private func actionButton(title: String, icon: String, color: Color, xp: Int) -> some View {
        Button(action: {
            processAnswer(earnedXP: xp)
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption.bold())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                LinearGradient(colors: [color.opacity(0.8), color], startPoint: .top, endPoint: .bottom)
            )
            .cornerRadius(16)
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
    
    // MARK: - Animations & Logic
    private func flipCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isFlipped.toggle()
            cardRotation += 180
        }
    }
    
    private func processAnswer(earnedXP: Int) {
        // 1. Trigger the bounce and floating XP animation if they scored points
        if earnedXP > 0 {
            floatingXPAmount = earnedXP
            floatingXPOpacity = 1.0
            floatingXPOffset = 0
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                cardScale = 1.05 // Bounce up
            }
            
            withAnimation(.easeOut(duration: 0.8)) {
                floatingXPOffset = -150 // Float up
                floatingXPOpacity = 0.0 // Fade out
            }
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.2)) {
                cardScale = 1.0 // Bounce back down
            }
        }
        
        // 2. Wait a moment for the animation to play before changing the card
        let delay = earnedXP > 0 ? 0.8 : 0.2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            userXP += earnedXP
            sessionXP += earnedXP
            
            if currentIndex < deck.cards.count - 1 {
                // Reset card visually instantly, then increment index
                isFlipped = false
                cardRotation = 0
                currentIndex += 1
            } else {
                withAnimation(.easeIn) {
                    isFinished = true
                }
            }
        }
    }
    
    // MARK: - Completion Screen
    private var completionScreen: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 150, height: 150)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(
                        LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                    )
                    .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
            }
            
            Text("Mastery Achieved!")
                .font(.system(size: 32, weight: .heavy, design: .rounded))
                .foregroundColor(.primary)
            
            Text("You earned +\(sessionXP) XP")
                .font(.title2.bold())
                .foregroundColor(.green)
                .padding()
                .background(Color.green.opacity(0.2))
                .cornerRadius(16)
        }
    }
}
