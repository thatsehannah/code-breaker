//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 9/13/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Shared with Me
    let game: CodeBreaker // since CodeBreaker is a class now, the pointer itself (since classes are passed by reference) is a constant, doesn't mean the object itself is a constant (can still change the properties)
    
    // MARK: Data Owned by Me
    
    @State private var selection: Int = 0
    @State private var restarting: Bool = false
    @State private var hideMostRecentResult = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: makeGuess)
                            .flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                ForEach(game.attempts, id: \.blocks) { attempt in
                    CodeView(code: attempt) {
                        let showResults = !hideMostRecentResult || attempt.blocks != game.attempts.first?.blocks
                        if showResults, let results = attempt.comparisonResults {
                            MatchOptionResults(results: results)
                        }
                    }
                    .transition(AnyTransition.attemptTransition(game.isOver))
                }
            }
            if (!game.isOver) {
                BlockChooserView(choices: game.blockChoices, onSelect: changeBlockAtSelection)
                    .transition(.blockChooserTransition) // point of origin is the upper left corner, so a positive y is down, and negative y is up
                    .frame(maxHeight: 90)
            }
            
            
        }
        .toolbar { // it's parent view must be wrapped in a NavigationStack for this to show up
            ToolbarItem(placement: .primaryAction) { // if one thing in toolbar is wrapped with ToolbarItem, all must be wrapped in a ToolbarItem
                Button("Restart Game", systemImage: "arrow.circlepath", action: restartGame)
            }
            ToolbarItem(placement: .automatic) {
                ElapsedTimeView(startTime: game.startTime, endTime: game.endTime)
                    .monospaced()
                    .lineLimit(1) // caps the max number of lines this view can occupy
            }
        }
        .padding()
    }
    
    func changeBlockAtSelection(to block: Block) {
        game.setGuessBlock(block, at: selection)
        selection = (selection + 1) % game.blockChoices.count
        
    }
    
    func restartGame() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restartGame()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                
                restarting = false
            }
        }
    }
    
    func makeGuess() {
        withAnimation(.guess) {
            game.submitGuess()
            selection = 0
            hideMostRecentResult = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentResult = false
            }
        }
    }
    
    func convertStringToColor(for blocks: [Block]) -> [Color] {
        return blocks.map { block in
            if let color = Color(name: block) {
                return color
            }
            
            return Color.clear
        }
    }
}



#Preview {
    @Previewable @State var game = CodeBreaker() // @State variables should be private UNLESS using @Previewable
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
