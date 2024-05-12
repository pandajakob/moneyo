//
//  ContentView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct BubbleView: View {
    @State private var showPopOver = false
    @EnvironmentObject var vm: ViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                if vm.state == .working {
                    ProgressView()
                }
                else {
                    VStack {
                        Spacer()
                    }
                    ForEach(vm.bubbles) { bubble in
                        BubbleCircleView(bubble: bubble)
                            .environmentObject(vm)
                            .foregroundStyle(AppColors().stringToColor(for: bubble.color))
                 
                    }
                    
                    
                    ForEach(vm.expensesNotInABubble) { expense in
                        ExpenseRectangleView(expense: expense)
                            .foregroundStyle(.black)
                            .frame(width: 150, height: 60)
                            .environmentObject(vm)
                    }
                    
                    AddExpenseView()
                        .environmentObject(vm)
                        .sheet(isPresented: $showPopOver) {
                            AddBubbleView(createAction: vm.makeCreateAction())
                                .environmentObject(vm)
                                .presentationDetents([.height(300)])
                        }
                    
                }
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
