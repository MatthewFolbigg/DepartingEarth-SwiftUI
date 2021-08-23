//
//  TagStyleModifier.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 23/08/2021.
//

import SwiftUI

struct TagStyleModifier: ViewModifier {
    
    let color: Color
    
    @Environment(\.colorScheme) private var colorScheme
    var isDark: Bool { colorScheme == .dark }
    var multiplyColor: Color { isDark ? .app.textPrimary : .app.textSecondary }
    var backgroundOpacity: Double { isDark ? 0.35 : 0.25 }
    var backgroundSaturation: Double { isDark ? 2 : 1 }
    
    func body(content: Content) -> some View {
        content
            .font(.app.listItemRegular)
            .lineLimit(1)
            .foregroundColor(color)
            .colorMultiply(multiplyColor)
            .saturation(isDark ? 3 : 1)
            .padding(4)
            .padding(.trailing, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(color)
                    .saturation(backgroundSaturation)
                    .opacity(backgroundOpacity)
                    .contrast(2)
            )
    }
    
}

extension Label {
    func tagStyle(color: Color) -> some View {
        self.modifier(TagStyleModifier(color: color))
    }
}


