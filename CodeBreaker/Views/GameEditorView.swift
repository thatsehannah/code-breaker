//
//  GameEditorView.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 10/27/26.
//

import SwiftUI

struct GameEditorView: View {
    @Bindable var game: CodeBreaker // You have permission to use this Observable (look this up)
    
    // TODO: Try to create a @Bindable computed property for the game's block choices
    
    var body: some View {
        Form {
            Section("Name") {
                TextField("Name", text: $game.name)
            }
            Section("Blocks") {
                List {
                    ForEach(game.blockChoices.indices, id: \.self) { index in
                        if game.blockChoices[index].count > 1 {
                            ColorPicker(selection: Binding(
                                get: { Color(name: game.blockChoices[index]) ?? .gray },
                                set: { newColor in
                                    if let name = newColor.name {
                                        game.blockChoices[index] = name
                                    }
                                }
                            ),
                                        supportsOpacity: false) {
                                Text("Block Choice #\(index + 1)")
                            }
                        } else {
                            LabeledContent("Block Choice #\(index + 1)") {
                                TextField("Emoji", text: Binding(
                                    get: { game.blockChoices[index] },
                                    set: { newValue in
                                        if let lastChar = newValue.last, Color(name: newValue) == nil {
                                            game.blockChoices[index] = String(lastChar)
                                        }
                                    })
                                )
                                .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    @Previewable var game = CodeBreaker(blockChoices: ["orange", "😀", "yellow", "green"], name: "Preview")
    GameEditorView(game: game)
        .onChange(of: game.name) {
            print("game name changed to \(game.name)")
        }
        .onChange(of: game.blockChoices) {
            print("game block choices changed to \(game.blockChoices)")
        }
    
}
