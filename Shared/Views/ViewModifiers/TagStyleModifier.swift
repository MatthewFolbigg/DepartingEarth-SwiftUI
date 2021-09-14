//
//  TagStyleModifier.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 23/08/2021.
//

import SwiftUI

struct TagStyleModifier: ViewModifier {
    
    let color: Color
    let cornerRadius: CGFloat
    
    @Environment(\.colorScheme) private var colorScheme
    var isDark: Bool { colorScheme == .dark }
    var multiplyColor: Color { isDark ? .app.textPrimary : .app.textSecondary }
    var backgroundOpacity: Double { isDark ? 0.35 : 0.25 }
    var backgroundSaturation: Double { isDark ? 2 : 1 }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .colorMultiply(multiplyColor)
            .saturation(isDark ? 3 : 1)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .foregroundColor(color)
                    .saturation(backgroundSaturation)
                    .opacity(backgroundOpacity)
                    .contrast(2)
            )
    }
    
}

extension View {
    func tagStyle(color: Color, cornerRadius: CGFloat = 10) -> some View {
        self.modifier(TagStyleModifier(color: color, cornerRadius: cornerRadius))
    }
}


