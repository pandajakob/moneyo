//
//  CtgryCircleView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct BubbleCircleView: View {
    @EnvironmentObject var vm: ViewModel
    
    let bubble: Bubble
    
    let maxWidth = UIScreen.main.bounds.width
    let maxHeigth = UIScreen.main.bounds.height
    
    @GestureState var locationState = CGPoint(x: 200, y: 200)
    @State private var location = CGPoint()
    
    @State var expenses = [Expense]()
    
    var sumOfAllExpenses: Double {
        withAnimation {
            vm.sumOfAllExpenses()
        }
    }
    var sumOfExpenses: Double {
        withAnimation {
            vm.sumOfExpenses(for: bubble)
        }
    }
    
    var frame: CGFloat {
        let screenArea = maxWidth*maxHeigth
        var bubbleArea: Double {
            return screenArea * sumOfExpenses/sumOfAllExpenses
        }
        let bubbleDiameter = sqrt(bubbleArea/Double.pi)*1.2
        if bubbleDiameter > 130 {
            return CGFloat(bubbleDiameter)
        } else {
            return CGFloat(130)
        }
    }
    
    @State var deleteConfirmationIsPresented = false
    @State var dataViewIsPresented = false
    
    var body: some View {
        NavigationStack {
            Circle()
                .frame(width: frame, height: frame)
                .overlay {
                    VStack {
                        Text(bubble.name)
                            .font(.headline)
                        Text("\(Int(sumOfExpenses))💰")
                            .font(.callout)
                    }
                    .foregroundStyle(.white)
                }
                .contextMenu {
                    Button {
                    } label: {
                        HStack {
                            Text("edit")
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    
                    Button {
                        deleteConfirmationIsPresented.toggle()
                    } label: {
                        HStack {
                            Text("delete")
                            Image(systemName: "trash")
                        }
                    }
                }
                .position(location)
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .updating($locationState) { currentState, pastState, transaction in
                        pastState = currentState.location
                        transaction.animation = .easeInOut
                        
                    }
                    .onChanged { state in
                        withAnimation {
                            location = state.location
                            saveLocations(bubble: bubble)
                        }
                    })
                .onTapGesture {
                    dataViewIsPresented.toggle()
                }
        }
        .dropDestination(for: Expense.self, action: { expense, location in
            var grabbedExpense = expense[0]
            grabbedExpense.bubbleId = bubble.id
            withAnimation(.bouncy(duration: 1.3)) {
                vm.expensesInBubbles.append(grabbedExpense)
                vm.expensesNotInABubble.removeAll(where: { $0.id == grabbedExpense.id})
                expenses.append(grabbedExpense)
            }
            Task {
                do {
                    try await vm.addExpenseToBubble(bubble: bubble, expense: grabbedExpense)
                }
            }
            return true
        })
        .task {
            loadLocations(bubble: bubble)
            expenses = await vm.fetchExpensesForBubble(bubble: bubble)
        }
        .sheet(isPresented: $dataViewIsPresented) {
            BubbleExpenseDataView(expenses: $expenses, bubble: bubble)
                .environmentObject(vm)
        }
        .confirmationDialog("delete bubble", isPresented: $deleteConfirmationIsPresented) {
            Button("delete bubble", role: .destructive) { vm.deleteBubble(bubble: bubble)
                vm.bubbles.removeAll(where: {$0.id == bubble.id}) // update UI
            }
        } message: {
            Text("Are you sure you want to delete this bubble?")
        }
    }
    
    let defaults = UserDefaults.standard
    
    func saveLocations(bubble: Bubble) {
        let x: Double = location.x
        let y: Double = location.y
        
        defaults.set(x, forKey: bubble.id.uuidString + "x")
        defaults.set(y, forKey: bubble.id.uuidString + "y")
    }
    
    func loadLocations(bubble: Bubble) {
        let x = defaults.double(forKey: bubble.id.uuidString + "x")
        let y = defaults.double(forKey: bubble.id.uuidString + "y")
        location = CGPoint(x: x, y: y)
    }
}




#Preview {
    BubbleCircleView(bubble: Bubble(name: "Bubble", color: "red"))
}


