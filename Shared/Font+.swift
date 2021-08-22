//
//  Font+.swift
//  Departing Earth
//
//  Created by Matthew Folbigg on 22/08/2021.
//

import SwiftUI

extension Font {
    
    static let app = AppTheme()
    
    struct AppTheme {
        //let x = Font.system(<#T##style: Font.TextStyle##Font.TextStyle#>, design: design).weight(<#T##weight: Font.Weight##Font.Weight#>)
        
        private static let design: Font.Design = .default
                
        //Countdowns
        let countdown = Font.system(.body, design: design).weight(.regular)
        
        //Information Sections
        let sectionTitle = Font.system(.title2, design: design).weight(.medium)
        let sectionDefault =  Font.system(.subheadline, design: design).weight(.regular)
        let sectionParagraph = Font.system(.body, design: design).weight(.thin)
        let sectionCaption = Font.system(.caption, design: design).weight(.thin)
        
        
        //List Items
        let listItemProminent   = Font.system(.headline, design: design).weight(.black)
        let listItemRegular     = Font.system(.subheadline, design: design).weight(.regular)
        let listItemLight       = Font.system(.subheadline, design: design).weight(.ultraLight)
        
        
    }
}
