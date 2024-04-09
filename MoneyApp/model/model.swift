//
//  model.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct Bubble: Identifiable, Transferable, Codable {
    var id = UUID()
    
    var name: String
//    var expenses: [Expense]
    
//    var sumOfExpenses: Double {
//        var sum = 0.0
//        expenses.forEach { expense in
//           sum += expense.price
//        }
//        return sum
//    }
    
    var color: String = AppColors.colors.randomElement()?.description ?? "red"
  
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .category)
    } 
}


struct Expense: Identifiable, Codable, Transferable {
    var id = UUID()
    var price: Double
    
    var timestamp = Date()
    
    var bubbleId: UUID?
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .expense)
    }
}


extension UTType {
    static let category = UTType(exportedAs: "Jakob-Michalesen.bubble")
    static let expense = UTType(exportedAs: "Jakob-Michalesen.expense")

}






