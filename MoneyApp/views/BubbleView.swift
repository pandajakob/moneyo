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
                            withAnimation {
                                
                                guard var index = vm.bubbles.firstIndex(where: {$0.id == bubble.id}) else { return }
                                
                                
                                withAnimation {
                                    vm.bubbles[index].expenses.append(contentsOf: expense)
                                    
                                    vm.updateBouble(bubble: vm.bubbles[index])
                                }
                                
                                for exp in expense {
                                    vm.expenses.removeAll(where: {$0.id == exp.id})
                                }
                            }
                            return true
                        })
                }
                
                
                ForEach(vm.expenses) { expense in
                    ExpenseRectangleView(expense: expense)
                        .foregroundStyle(.gray)
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
