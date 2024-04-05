//
//  ViewModel.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var bubbles = [Bubble]()
    @Published var expensesToAdd = [Expense]()
    
    @Published var currency = "💰"

    
    
    init() {
        bubbles = [
            Bubble(name: "cat1", expenses: [Expense(price: 100.0, name: "cake")]),
            Bubble(name: "cat2", expenses: [Expense(price: 400.0, name: "cake")]),
            Bubble(name: "cat3", expenses: [Expense(price: 200.0, name: "cake")]),
            Bubble(name: "cat4", expenses: [Expense(price: 500.0, name: "cake")]),
            Bubble(name: "cat5", expenses: [Expense(price: 250.0, name: "cake")]),
        ]
    }
}






//private func circles() {
//    let maxWidth = UIScreen.main.bounds.width
//    let maxHeigth = UIScreen.main.bounds.width
//
//    for i in data.indices {
//        
//        let catShare = data[i].sumOfExpenses / totalSpent()
//        
//        let width = maxWidth*catShare
//        
//        print("category share", catShare)
//        print("maxwidth:", maxWidth)
//        print("width:", width)
//
//        data[i].frame = width
//
//        
//        data[i].position = (CGFloat.random(in: 50...maxWidth), CGFloat.random(in: 50...maxHeigth))
//        
//        print("position:", "x:",data[i].position.x, "y:", data[i].position.y)
//
//        
//        
//    }
//}
//private func totalSpent() -> Double {
//    var sum = 0.0
//       data.forEach { cat in
//            sum += cat.sumOfExpenses
//        }
//        return sum
//}

