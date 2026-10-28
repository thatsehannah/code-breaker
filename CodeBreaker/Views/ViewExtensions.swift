//
//  ViewExtensions.swift
//  CodeBreaker
//
//  Created by Elliot Hannah III on 10/5/26.
//

import SwiftUI

extension View {
    func flexibleSystemFont(minimum: CGFloat = 8, maximum: CGFloat = 80) -> some View {
        self
            .font(.system(size: maximum))
            .minimumScaleFactor(minimum/maximum)
    }
}

extension Animation {
    static let codeBreaker = Animation.bouncy
    static let guess = Animation.codeBreaker
    static let restart = Animation.codeBreaker
    static let select = Animation.codeBreaker
}

extension AnyTransition {
    static let blockChooserTransition = AnyTransition.offset(x: 0, y: 200)
    
    static func attemptTransition(_ isOver: Bool) -> AnyTransition {
        return AnyTransition.asymmetric(
            insertion: isOver ? .opacity : .move(edge: .top),
            removal: .move(edge: .trailing))
    }
}

extension Color {
    static let palette: [String: Color] = [
        "green": .green,
        "yellow": .yellow,
        "red": .red,
        "orange": .orange,
        "black": .black,
        "blue": .blue,
        "clear": .clear,
        "purple": .purple,
        "pink": .pink,
        "cyan": .cyan,
        "indigo": .indigo,
        "brown": .brown,
        "teal": .teal,
    ]
    
    init?(name: String) {
        guard let color = Color.palette[name] else { return nil }
        self = color
    }
    
    var name: String? {
        Color.palette.first { $0.value == self }?.key
    }
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        return Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}
