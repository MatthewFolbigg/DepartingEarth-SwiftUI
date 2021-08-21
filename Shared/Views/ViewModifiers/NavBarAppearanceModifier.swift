//
//  NavBarAppearanceModifier.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 21/08/2021.
//

import SwiftUI

struct navBarAppearanceModifier: ViewModifier {
    
    init(forground: Color, background: Color, tint: Color, hasSeperator: Bool, seperator: Color) {
        let navBarAppearance = UINavigationBarAppearance()
        //Forground
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(forground)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(forground)]
        //Background
        navBarAppearance.backgroundColor = UIColor(background)
        //Seperator
        if hasSeperator { navBarAppearance.shadowColor = UIColor(seperator)
        } else { navBarAppearance.shadowColor = .clear } //Hides Sepeator

        //Tint
        UINavigationBar.appearance().tintColor = UIColor(tint)
        
        //Set Appearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    func body(content: Content) -> some View {
        content
    }
    
}

extension View {
    
    func navBarAppearance(forground: Color, background: Color, tint: Color, hasSeperator: Bool = true, seperator: Color = .primary) -> some View {
        self.modifier(navBarAppearanceModifier(
                        forground: forground,
                        background: background,
                        tint: tint,
                        hasSeperator: hasSeperator,
                        seperator: seperator))
    }
    
}
