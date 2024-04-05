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
                    BubbleCircleView(frame: CGFloat.random(in: 100...300), bubble: bubble)
                        .foregroundStyle(AppColors().stringToColor(for: bubble.color))
                        .environmentObject(vm)
                        .dropDestination(for: Expense.self, action: { expense, location in
                            withAnimation {
                                
                                guard var datapoint = vm.bubbles.first(where: {$0.id == bubble.id}) else {return}
                                print(datapoint)
                                print("expense", expense)
                                datapoint.expenses.append(contentsOf: expense)
                                
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
                    .sheet(isPresented: $showPopOver) {
                        AddBubbleView(createAction: vm.makeCreateAction())
                            .environmentObject(vm)
                            .presentationDetents([.height(300)])
                    }
                
            }
            .onAppear {
                vm.fetchBubbles()
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
