//
//  ContentView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct BubbleView: View {
    
    @StateObject var vm = ViewModel()
    @State private var showPopOver = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ForEach(vm.bubbles) { bubble in
                    BubbleCircleView(bubble: bubble)
                        .foregroundStyle(AppColors().stringToColor(for: bubble.color))
                        .environmentObject(vm)
                        .dropDestination(for: Expense.self, action: { expense, location in
                            
                            var grabbedExpense = expense[0]
                            grabbedExpense.bubbleId = bubble.id
                            Task {
                                do {
                                    try await vm.addExpenseToBubble(bubble: bubble, expense: grabbedExpense)
                                    vm.fetchAllExpensesNotInABubble()
                                }
                            }
                            
                            return true
                        })
                }
                
                
                ForEach(vm.expensesNotInABubble) { expense in
                    ExpenseRectangleView(expense: expense)
                        .foregroundStyle(.black)
                        .frame(width: 150, height: 60)
                        .environmentObject(vm)
                    
                }
                
                FormView()
                    .environmentObject(vm)
                    .sheet(isPresented: $showPopOver) {
                        AddBubbleView(createAction: vm.makeCreateAction())
                            .environmentObject(vm)
                            .presentationDetents([.height(300)])
                    }
                
            }
            .onAppear {
                vm.fetchBubbles()
                vm.fetchAllExpensesNotInABubble()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPopOver.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    
                    
                }
            }
        }
    }
    
    
}

#Preview {
    BubbleView()
}
