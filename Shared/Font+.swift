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
        
        //Main UI
        let activityIndicator = Font.system(.title3, design: design).weight(.semibold)
        
        //Countdowns
        let countdown = Font.system(.footnote, design: design).weight(.semibold)
        
        //Information Sections
        let sectionTitle = Font.system(.title2, design: design).weight(.medium)
        let sectionDefault =  Font.system(.subheadline, design: design).weight(.regular)
        let sectionParagraph = Font.system(.body, design: design).weight(.thin)
        let sectionCaption = Font.system(.caption, design: design).weight(.thin)
        
        //List Items
        let listItemProminent   = Font.system(.headline, design: design).weight(.black)
        let listItemRegular     = Font.system(.subheadline, design: design).weight(.regular)
        let listItemLight       = Font.system(.subheadline, design: design).weight(.ultraLight)
        
        //row
        let rowTitle = Font.system(.title3, design: design).weight(.black)
        let rowSubtitle = Font.system(.title3, design: design).weight(.semibold)
        let rowElement = Font.system(.subheadline, design: design).weight(.regular)
        let rowDetail = Font.system(.caption, design: design).weight(.semibold)
        
    }
}
