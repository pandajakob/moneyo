//
//  AppColors.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import Foundation
import SwiftUI

struct AppColors {
    static var colors: [Color] = [.blue, .red, .orange, .yellow, .cyan, .green, .pink]
    
    static var backgroundColor: Color = .orange
    func stringToColor(for string: String) -> Color {
        
        for color in BubbleColors.allCases {
            if string == color.rawValue {
                return color.color
            }
        }
        
        return Color.blue
    }

    
}


enum BubbleColors: String, CaseIterable {
    case blue, red, orange, yellow, cyan, green, pink
    var color: Color {
        switch self {
        case .blue:
            return Color.blue
        case .red:
            return Color.red
        case .orange:
            return Color.orange
        case .yellow:
            return Color.yellow
        case .cyan:
            return Color.cyan
        case .green:
            return Color.green
        case .pink:
            return Color.pink
        }
        
    }
    
}
