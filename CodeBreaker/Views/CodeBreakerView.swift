//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 9/13/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game = CodeBreaker()
    @State private var selection: Int = 0
    @State private var restarting: Bool = false
    @State private var hideMostRecentResult = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode) {
//                ElapsedTimeView(startTime: game.startTime, endTime: game.endTime)
//                    .flexibleSystemFont()
//                    .monospaced()
//                    .lineLimit(1) // caps the max number of lines this view can occupy
            }
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
                BlockChooser(choices: game.blockChoices, onSelect: changeBlockAtSelection)
                    .transition(.blockChooserTransition) // point of origin is the upper left corner, so a positive y is down, and negative y is up
            }
            
            Button("Restart Game", systemImage: "arrow.circlepath", action: restartGame)
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
            game = CodeBreaker()
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
    CodeBreakerView()
}
