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
    
    @Published var state: LoadState = .idle
    
    @Published var currency = "💰"
    
    func makeCreateAction() -> AddBubbleView.CreateAction {
        return { [weak self] data in
            try await BubbleRepository.create(data)
            self?.bubbles.insert(data, at: 0)
        }
    }
    
    func fetchBubbles() async {
        Task {
            state = .working
            do {
                
                bubbles = try await BubbleRepository.fetchAllBubbles()
                print("fetched bubbles succesfully")
                self.state = .idle
                
            }
            catch {
                print("[ViewModel] couldn't fetch data \(error)")
                state = .error
                
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
            state = .working
            do {
                expensesInBubbles = try await BubbleRepository.fetchExpensesForBubble(bubble: bubble)
                print("fetched expenses for bubble successfully")
                state = .idle
            }
            catch {
                print("[viewModel] couldn't fetch expenses for bubble")
                state = .error
                
            }
        }
    }
    
    func deleteBubble(bubble: Bubble) {
        
        Task {
            state = .working
            do {
                try await BubbleRepository.deleteBubble(bubble: bubble)
                bubbles.removeAll(where: {$0.id == bubble.id})
                print("deleted bubble successfully")
                state = .idle
            }
            catch {
                print("[ViewModel] couldn't delete bubble")
                state = .error
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
    
    func getSumOfAllExpensesInABubble() async -> Double {
        var sum = 0.0
        state = .working
        do {
            return try await ExpenseRepository.getSumOfAllExpensesInABubble()
            state = .idle
        }
        catch {
            print("Couldn't get sum of all expenses \(error)")
            state = .error
        }
        print("sum of all expenses", sum)
        return sum
    }
    
    func getSumOfExpensesForBubble(bubble: Bubble) async -> Double {
        var sum = 0.0
        state = .working
        do {
            sum = try await BubbleRepository.getSumOfExpensesForBubble(bubble: bubble)
            state = .idle
            
        } catch {
            print("Couldn't get sum of expense for bubble \(error)")
            state = .error
        }
        return sum
    }
    
    
    enum LoadState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else { return }
                self = .idle
            }
        }
    }

}

