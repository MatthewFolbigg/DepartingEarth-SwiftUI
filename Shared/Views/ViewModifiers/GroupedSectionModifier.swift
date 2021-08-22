//
//  GroupedSectionModifier.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 22/08/2021.
//

import SwiftUI

struct GroupedSectionModifier: ViewModifier {
    
    var edgeInsets: EdgeInsets
    var forgroundColor: Color
    var backgroundColor: Color
    var cornerRadius: CGFloat
    
    init(forgroundColor: Color, backgroundColor: Color, cornerRadius: CGFloat, padding: CGFloat) {
        self.forgroundColor = forgroundColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.edgeInsets = EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
    }
    
    var background: some View {
        backgroundColor
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(forgroundColor)
            .padding(edgeInsets)
            .background(background)
    }
}

extension View {
    func groupedSection(forgroundColor: Color = .app.textPrimary, backgroundColor: Color = .app.backgroundPrimary, cornerRadius: CGFloat = 20, padding: CGFloat = 20) -> some View {
        self.modifier(GroupedSectionModifier(forgroundColor: forgroundColor, backgroundColor: backgroundColor, cornerRadius: cornerRadius, padding: padding))
    }
}
