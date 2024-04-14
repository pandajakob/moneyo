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
    @Published var expensesInBubbles: [Expense] = []
    @Published var allExpensesInABubble: [Expense] = []
    
    @Published var isLoading: Bool = false
    
    @Published var currency = "💰"
    
    func makeCreateAction() -> AddBubbleView.CreateAction {
        return { [weak self] data in
            try await BubbleRepository.create(data)
            self?.bubbles.insert(data, at: 0)
        }
    }
    
    func fetchBubbles() async {
        Task {
            isLoading = true
            do {
                
                bubbles = try await BubbleRepository.fetchAllBubbles()
                print("fetched bubbles succesfully")
                self.isLoading = false
                
            }
            catch {
                isLoading = false
                print("[ViewModel] couldn't fetch data \(error)")
            }
        }
    }
    
    func fetchAllExpensesInABubble() {
        Task {
            do {
                allExpensesInABubble = try await ExpenseRepository.fetchAllExpenses(filter: { $0.bubbleId != nil })
                print("fetched all expenses in a bubble successfully")
                
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
                print("added expenses successfully")
                
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
                print("fetched all expenses not in a bubble successfully")
                
            } catch {
                print("[viewModel] couldn't fetch expenses")
            }
        }
    }
    
    func addExpenseToBubble(bubble: Bubble, expense: Expense) async throws {
        Task {
            do {
                try await BubbleRepository.addExpenseToBubble(bubble: bubble, expense: expense)
                print("added expenses to bubble successfully")
                
            } catch {
                print("[viewModel] couldn't add expense to bubble")
            }
        }
    }
    
    func fetchExpensesForBubble(bubble: Bubble) async {
        Task {
            isLoading = true
            do {
                expensesInBubbles = try await BubbleRepository.fetchExpensesForBubble(bubble: bubble)
                print("fetched expenses for bubble successfully")
                self.isLoading = false
            }
            catch {
                print("[viewModel] couldn't fetch expenses for bubble")
                self.isLoading = false

            }
        }
    }
    
    func deleteBubble(bubble: Bubble) {
        Task {
            do {
                try await BubbleRepository.deleteBubble(bubble: bubble)
                bubbles.removeAll(where: {$0.id == bubble.id})
                print("deleted bubble successfully")
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
                print("deleted expense successfully")
                
            }
            catch {
                print("[ViewModel] couldn't delete bubble")
            }
        }
    }
}
