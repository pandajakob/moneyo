//
//  ContentView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct BubbleView: View {
    
    @StateObject var vm = ViewModel()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                ForEach(vm.bubbles) { bubble in
                    BubbleCircleView(frame: CGFloat.random(in: 100...300), bubble: bubble)
                        .foregroundStyle(AppColors.colors.randomElement() ?? Color.black)
                        .environmentObject(vm)
                        .dropDestination(for: Expense.self, action: { expense, location in
                            withAnimation {
                                var datapoint = vm.bubbles.first(where: {$0.id == bubble.id})
                                datapoint?.expenses.append(contentsOf: expense)
                                
                                for exp in expense {
                                    vm.expensesToAdd.removeAll(where: {$0.id == exp.id})
                                }   
                            }
                            return true
                        })
                }
                
                
                ForEach(vm.expensesToAdd) { expense in
                    ExpenseRectangleView(expense: expense)
                        .foregroundStyle(.red)
                        .frame(width: 150, height: 60)
                        .environmentObject(vm)
                    
                }
                
                FormView()
                    .environmentObject(vm)
                
            }
        }
    }
}

#Preview {
    BubbleView()
}
