//
//  GameListView.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 10/27/26.
//

import SwiftUI

struct GameListView: View {
    @State var games: [CodeBreaker] = []
    
    @Binding var selection: CodeBreaker?
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(blockChoices: ["green", "red", "blue", "yellow"], name: "Mastermind"))
            games.append(CodeBreaker(blockChoices: ["green", "😃", "purple", "🥶", "pink", "🔔"], name: "Random"))
            games.append(CodeBreaker(blockChoices: ["🍊", "❤️", "💩", "😶‍🌫️", "🤡"], name: "Emoji"))
            games.append(CodeBreaker(blockChoices: ["blue", "indigo", "cyan"], name: "Undersea"))
            selection = games.last
        }
    }
    
    func addNewGame(name: String, blockChoices: [Block]) {
        games.append(CodeBreaker(blockChoices: blockChoices, name: name))
    }
    
    var body: some View {
        List(selection: $selection) {
            ForEach(games) { game in // expose the ForEach like this when your model (i.e. game) is a class; also when a class (or struct) conforms to Identifiable, we don't need to pass in the id param for ForEach
                NavigationLink(value: game) {
                    GameSummary(game: game)
                }
                .contextMenu { // shows a right click menu on Mac (activates by pressing on an item on iOS)
                    Button("Delete", systemImage: "minus.circle", role: .destructive) {
                        withAnimation {
                            games.removeAll { $0 == game }
                        }
                    }
                }
            }
            .onDelete { offsets in // this and .onMove are used instead of editActions (in the List init) if your model is a class
                games.remove(atOffsets: offsets)
            }
            .onMove { offset, destination in
                games.move(fromOffsets: offset, toOffset: destination)
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        
        .listStyle(.plain)
        .toolbar { // Navigation Stack puts the toolbar at the top. this is also necessary if you have editActions defined in List (editActions only work on bindable arguments, e.g $game -> fact check this)
            Button("Add Game", systemImage: "plus") {
                withAnimation {
                    addNewGame(name: "Untitled", blockChoices: ["🙈", "green", "🏀"])
                }
            }
            EditButton()
        }
        .onAppear { addSampleGames() }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameListView(selection: $selection)
    }
}
