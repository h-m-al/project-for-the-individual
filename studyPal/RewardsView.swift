import SwiftUI

struct RewardsView: View {
    // Just a regular variable since this view only reads the data, it doesn't change it
    let userXP: Int
    
    let badges = [
        Badge(name: "Novice Scholar", requiredXP: 30, icon: "star.fill"),
        Badge(name: "Adept Learner", requiredXP: 90, icon: "medal.fill"),
        Badge(name: "Master Architect", requiredXP: 180, icon: "crown.fill")
    ]
    
    var currentLevel: Int { (userXP / 100) + 1 }
    var progressToNextLevel: Double { Double(userXP % 100) / 100.0 }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Level \(currentLevel)")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                            .foregroundColor(.accentColor)
                        
                        Text("Total Points: \(userXP) XP")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        ProgressView(value: progressToNextLevel)
                            .padding(.horizontal)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Achievements").font(.title2).bold()
                        
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(badges) { badge in
                                let isUnlocked = userXP >= badge.requiredXP
                                
                                VStack(spacing: 8) {
                                    Image(systemName: badge.icon)
                                        .font(.system(size: 36))
                                        .foregroundColor(isUnlocked ? .yellow : .gray.opacity(0.3))
                                    
                                    Text(badge.name).font(.subheadline).bold().multilineTextAlignment(.center)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Player Profile")
        }
    }
}
