//
//  GameSummary.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 10/12/26.
//

import SwiftUI

struct GameSummary: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            BlockChooserView(choices: game.blockChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)") // ^[expression](inflect: true) pluralizes something that is not plural 😱
        }
    }
}

#Preview {
    List {
        GameSummary(game: CodeBreaker())
        GameSummary(game: CodeBreaker())
    }
    .listStyle(.plain)
    
    List {
        GameSummary(game: CodeBreaker())
        GameSummary(game: CodeBreaker())
    }
}
