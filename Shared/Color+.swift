//
//  Color+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 06/08/2021.
//

import Foundation
import SwiftUI

extension Color {
    static let app = AppTheme()
    
    struct AppTheme {
        //Launch Status Colours
        let statusGreen = Color("StatusGreenLight")
        let statusGreenDark = Color("StatusGreenDark")
        let statusRed = Color("StatusRedLight")
        let statusRedDark = Color("StatusRedDark")
        
        let statusYellow = Color("StatusYellow")
        let statusOrange = Color("StatusOrange")
        
        //Text Colours
        let textPrimary = Color("Primary Text")
        let textSecondary = Color("Secondary Text")
        let textAccented = Color("App Accented Text")
        
        //Accents
        let control = Color("Control Accent One")
        let tracked = Color.orange //TODO: Placeholder Colour
        
        //Backgrounds
        let backgroundPlain = Color("Background Plain")
        let backgroundAccented = Color("App Accent")
        let backgroundPrimary = Color("Background Primary")
        
    }
    
}

