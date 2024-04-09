//
//  ViewModel.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import Foundation

@MainActor
class ViewModel: ObservableObject {
    
    @Published var bubbles: [Bubble] = []
    @Published var expensesNotInABubble: [Expense] = []
    @Published var expensesInBubble: [Expense] = []
    @Published var allExpensesInABubble: [Expense] = []

    @Published var currency = "💰"

    let defaults = UserDefaults.standard
  
    func makeCreateAction() -> AddBubbleView.CreateAction {
        return { [weak self] data in
            try await BubbleRepository.create(data)
            self?.bubbles.insert(data, at: 0)
        }
    }
    
    func fetchBubbles() {
        Task {
            do {
                bubbles = try await BubbleRepository.fetchAllBubbles()
            }
            catch {
                print("[ViewModel] couldn't fetch data \(error)")
            }
        }
    }
    
    func fetchAllExpensesInABubble() {
        Task {
            do {
                allExpensesInABubble = try await ExpenseRepository.fetchAllExpenses(filter: { $0.bubbleId != nil })
            }
            catch {
                print("[ViewModel] couldn't fetch data \(error)")
            }
        }
        
    }
    
    func addExpense(price: Double) {
        let newExpense = Expense(price: price)
        Task {
            do {
                try await ExpenseRepository.create(newExpense)
            }
            catch {
                print("[ViewModel] couldn't create expense \(error)")
            }
        }
        expensesNotInABubble.append(newExpense)
    }
    
    func fetchAllExpensesNotInABubble() {
        Task {
            do {
                expensesNotInABubble = try await ExpenseRepository.fetchAllExpenses(filter: { $0.bubbleId == nil })
            } catch {
                print("[viewModel] couldn't fetch expenses")
            }
        }
    }
    
    func addExpenseToBubble(bubble: Bubble, expense: Expense) async throws {
        Task {
            do {
                try await BubbleRepository.addExpenseToBubble(bubble: bubble, expense: expense)
            } catch {
                print("[viewModel] couldn't add expense to bubble")
            }
        }
    }
    
    func fetchExpensesForBubble(bubble: Bubble) {
        Task {
            do {
                expensesInBubble = try await BubbleRepository.fetchExpensesForBubble(bubble: bubble)
            }
            catch {
                print("[viewModel] couldn't fetch expenses for bubble")                
            }
        }
    }
    
    func deleteBubble(bubble: Bubble) {
        Task {
            do {
                try await BubbleRepository.deleteBubble(bubble: bubble)
                bubbles.removeAll(where: {$0.id == bubble.id})
            }
            catch {
                print("[ViewModel] couldn't delete bubble")
            }
        }
    }
    func deleteExpense(expense: Expense) {
        Task {
            do {
                try await ExpenseRepository.deleteExpense(expense: expense)
                allExpensesInABubble.removeAll(where: {$0.id == expense.id})
                expensesNotInABubble.removeAll(where: {$0.id == expense.id})
                expensesNotInABubble.removeAll(where: {$0.id == expense.id})
            }
            catch {
                print("[ViewModel] couldn't delete bubble")
            }
        }
    }
    
}




//init() {
//    bubbles = [
//        Bubble(name: "cat1", expenses: [Expense(price: 100.0, name: "cake")]),
//        Bubble(name: "cat2", expenses: [Expense(price: 400.0, name: "cake")]),
//        Bubble(name: "cat3", expenses: [Expense(price: 200.0, name: "cake")]),
//        Bubble(name: "cat4", expenses: [Expense(price: 500.0, name: "cake")]),
//        Bubble(name: "cat5", expenses: [Expense(price: 250.0, name: "cake")]),
//    ]
//}

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

