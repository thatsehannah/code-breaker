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
            List {
                ForEach(games) { game in // expose the ForEach like this when your model (i.e. game) is a class; also when a class (or struct) conforms to Identifiable, we don't need to pass in the id param for ForEach
                    NavigationLink(value: game) {
                        GameSummary(game: game)
                    }
                    NavigationLink(value: game.masterCode.blocks) {
                        Text("Cheat")
                    }
                }
                .onDelete { offsets in // this and .onMove are used instead of editActions (in the List init) if your model is a class
                    games.remove(atOffsets: offsets)
                }
                .onMove { offset, destination in
                    games.move(fromOffsets: offset, toOffset: destination)
                }
            }
            .navigationDestination(for: CodeBreaker.self) { game in // this corresponds to the NavigationLink that has a value of type CodeBreaker, and it displays the view that you want to show for when that navigation link is pressed.
                CodeBreakerView(game: game)
            }
            .navigationDestination(for: [Block].self) { blocks in // this corresponds to the NavigationLink that has a value of type array of Blocks and shows the BlockChooserView for it
                BlockChooserView(choices: blocks)
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
