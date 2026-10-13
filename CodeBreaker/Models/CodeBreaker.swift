//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 9/15/26.
//

import Foundation

typealias Block = String

@Observable class CodeBreaker { // whenever we have a class in our model, make it @Observable
    var name: String
    var masterCode: Code
    var guess: Code
    var attempts: [Code] = []
    let blockChoices: [Block]
    var startTime: Date = Date.now
    var endTime: Date?
    
    init(blockChoices: [Block] = ["🔥", "red", "🥶", "indigo"], name: String = "Code Breaker") {
        self.name = name
        self.blockChoices = blockChoices
        self.masterCode = Code(kind: .master(isHidden: true), blocks: Array(repeating: Code.empty, count: self.blockChoices.count))
        self.guess = Code(kind: .guess, blocks: Array(repeating: Code.empty, count: self.blockChoices.count))
        masterCode.createMasterCode(from: self.blockChoices)
        startTime = .now
        endTime = nil
        
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.first?.blocks == masterCode.blocks
    }
    
    func restartGame() {
        masterCode.kind = .master(isHidden: true)
        masterCode.createMasterCode(from: blockChoices)
        guess.resetGuess()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        
        print(masterCode)
    }
    
    func submitGuess() {
        guard guess.blocks.count(where: { block in block == Code.empty}) != blockChoices.count else { return }
        
        guard !attempts.contains(where: { $0.blocks == guess.blocks}) else { return }
        
        var attempt = guess
        attempt.kind = .attempt(guess.compareBlocks(against: masterCode))
        attempts.insert(attempt, at: 0)
        
        guess.resetGuess()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
            endTime = .now
        }
    }
    
    func setGuessBlock(_ block: Block, at index: Int) {
        guard guess.blocks.indices.contains(index) else { return }
        guess.blocks[index] = block
    }
    
    func changeGuessBlock(at index: Int) {
        let existingBlock = guess.blocks[index]
        if let indexOfExistingBlockInBlockChoices = blockChoices.firstIndex(of: existingBlock) {
            let newBlock = blockChoices[(indexOfExistingBlockInBlockChoices + 1) % blockChoices.count]
            guess.blocks[index] = newBlock
        } else {
            guess.blocks[index] = blockChoices.first ?? Code.empty
        }
    }
}

// best practice to have conformance logic in an extension
extension CodeBreaker: Identifiable, Hashable, Equatable { // Making a class Identifiable synthesizes it (i.e. creates an id property) because the id is actually the pointer
    
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) //Identifiable requires the id property be hashable
    }
    
}


