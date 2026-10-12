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
        List(games, id: \.blockChoices) { game in
            BlockChooser(choices: game.blockChoices)
        }
        .onAppear {
            games.append(CodeBreaker(blockChoices: ["green", "😃", "purple", "🥶"]))
            games.append(CodeBreaker(blockChoices: ["🍊", "❤️", "💩", "😶‍🌫️", "🤡"]))
            games.append(CodeBreaker(blockChoices: ["blue", "indigo", "cyan"]))
        }
    }
}

#Preview {
    GameChooserView()
}
