//
//  GameChooserView.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 10/12/26.
//

import SwiftUI

struct GameChooserView: View {
    // MARK: Data owned by me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        NavigationStack {
            List($games, id: \.blockChoices, editActions: [.delete, .move]) { $game in //adding $ to the state object makes it bindable
                NavigationLink {
                    CodeBreakerView(game: $game)
                } label: {
                    GameSummary(game: game)
                }
            }
            .listStyle(.plain)
            .toolbar { // Navigation Stack puts the toolbar at the top. this is also necessary if you have editActions defined in List (editActions only work on bindable arguments, e.g $game -> fact check this)
                EditButton()
            }
        }

        .onAppear {
            games.append(CodeBreaker(blockChoices: ["green", "red", "blue", "yellow"], name: "Mastermind"))
            games.append(CodeBreaker(blockChoices: ["green", "😃", "purple", "🥶", "pink", "🔔"], name: "Random"))
            games.append(CodeBreaker(blockChoices: ["🍊", "❤️", "💩", "😶‍🌫️", "🤡"], name: "Emoji"))
            games.append(CodeBreaker(blockChoices: ["blue", "indigo", "cyan"], name: "Undersea"))
        }
    }
}

#Preview {
    GameChooserView()
}
