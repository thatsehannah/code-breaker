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
            GameListView(selection: $selection)
                .navigationTitle("Code Breaker")
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
    }
}

#Preview {
    GameChooserView()
}
