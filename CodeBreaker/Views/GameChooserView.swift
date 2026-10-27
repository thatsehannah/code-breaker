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
    @State private var selection: CodeBreaker? = nil // if the value in the NavigationLink is the same type as the type of this var, it will set selection to that value
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            List(selection: $selection) {
                ForEach(games) { game in // expose the ForEach like this when your model (i.e. game) is a class; also when a class (or struct) conforms to Identifiable, we don't need to pass in the id param for ForEach
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                }
                .onDelete { offsets in // this and .onMove are used instead of editActions (in the List init) if your model is a class
                    games.remove(atOffsets: offsets)
                }
                .onMove { offset, destination in
                    games.move(fromOffsets: offset, toOffset: destination)
                }
            }
            .navigationTitle("Code Breaker")
            .listStyle(.plain)
            .toolbar { // Navigation Stack puts the toolbar at the top. this is also necessary if you have editActions defined in List (editActions only work on bindable arguments, e.g $game -> fact check this)
                EditButton()
            }
        } detail: {
            if let selection {
                CodeBreakerView(game: selection)
                    .navigationTitle(selection.name)
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                Text("Choose a game!")
            }
        }
        .navigationSplitViewStyle(.balanced)

        .onAppear {
            games.append(CodeBreaker(blockChoices: ["green", "red", "blue", "yellow"], name: "Mastermind"))
            games.append(CodeBreaker(blockChoices: ["green", "😃", "purple", "🥶", "pink", "🔔"], name: "Random"))
            games.append(CodeBreaker(blockChoices: ["🍊", "❤️", "💩", "😶‍🌫️", "🤡"], name: "Emoji"))
            games.append(CodeBreaker(blockChoices: ["blue", "indigo", "cyan"], name: "Undersea"))
            selection = games.last
        }
    }
}

#Preview {
    GameChooserView()
}
