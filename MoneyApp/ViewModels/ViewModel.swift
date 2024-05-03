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
    @Published var expensesInBubbles: [Expense] = []
    
    @Published var expensesNotInABubble: [Expense] = []
    
    @Published var state: LoadState = .idle
    
    @Published var currency = "💰"
    
    
    func sumOfExpenses(for bubble: Bubble) -> Double {
        var sum = 0.0
        expensesInBubbles.filter({$0.bubbleId == bubble.id }).forEach { Expense in
            sum += Expense.price
        }
        return sum
    }
    
    func sumOfAllExpenses() -> Double {
        var sum = 0.0
        bubbles.forEach { bubble in
            sum += sumOfExpenses(for: bubble)
        }
        return sum
    }
    
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

    func fetchAllExpenses() async {
        state = .working
        Task {
            do {
                expensesInBubbles = try await ExpenseRepository.fetchAllExpenses()
                print("fetched all expenses in a bubble successfully")
                state = .idle
            }
            catch {
                print("[ViewModel] couldn't fetch data \(error)")
                state = .error
            }
        }
    }
    
    func createExpense(price: Double) {
        let newExpense = Expense(price: price)
        expensesNotInABubble.append(newExpense)
    }
    
    
    func addExpenseToBubble(bubble: Bubble, expense: Expense) async throws {
        Task {
            do {
                try await BubbleRepository.addExpenseToBubble(bubble: bubble, expense: expense)
                try await ExpenseRepository.create(expense)
                print("added expenses to bubble successfully")
                
            } catch {
                print("[viewModel] couldn't add expense to bubble")
            }
        }
    }

    func fetchExpensesForBubble(bubble: Bubble) async -> [Expense] {
        var expenseArray: [Expense] = []
        
        do {
            expenseArray = try await BubbleRepository.fetchExpensesForBubble(bubble: bubble)
            print("fetched expenses for bubble successfully")
        }
        catch {
            print("[viewModel] couldn't fetch expenses for bubble")
        }
        return expenseArray
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
                expensesInBubbles.removeAll(where: {$0.id == expense.id})
                expensesNotInABubble.removeAll(where: {$0.id == expense.id})
                print("deleted expense successfully")
            }
            catch {
                print("[ViewModel] couldn't delete bubble")
            }
        }
    }
    
//    func getSumOfAllExpensesInABubble() async -> Double {
//        var sum = 0.0
//        state = .working
//        do {
//            sum = try await ExpenseRepository.getSumOfAllExpensesInABubble()
//            state = .idle
//        }
//        catch {
//            print("Couldn't get sum of all expenses \(error)")
//            state = .error
//        }
//        print("sum of all expenses", sum)
//        return sum
//    }
    
//    func getSumOfExpensesForBubble(bubble: Bubble) async -> Double {
//        var sum = 0.0
//        state = .working
//        do {
//            sum = try await BubbleRepository.getSumOfExpensesForBubble(bubble: bubble)
//            state = .idle
//            
//        } catch {
//            print("Couldn't get sum of expense for bubble \(error)")
//            state = .error
//        }
//        return sum
//    }
    
    
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

