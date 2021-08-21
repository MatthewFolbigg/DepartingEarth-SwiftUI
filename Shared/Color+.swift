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
        let statusGreen = Color("StatusGreen")
        let statusYellow = Color("StatusYellow")
        let statusRed = Color("StatusRed")
        let statusOrange = Color("StatusOrange")
        
        //Text Colours
        let textPrimary = Color("Primary Text")
        let textSecondary = Color("Secondary Text")
        
        //Accents
        let control = Color("Control Accent One")
        
        //Backgrounds
        let backgroundPlain = Color("Background Plain")
        let backgroundAccented = Color("Background Accented")
        let backgroundPrimary = Color("Background Primary")
        
    }
    
}

