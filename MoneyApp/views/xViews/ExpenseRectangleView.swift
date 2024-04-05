//
//  ExpenseRectangleView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct ExpenseRectangleView: View {
    
    let expense: Expense
    
    @GestureState var locationState = CGPoint(x: 100, y: 100)
    @State var location = CGPoint(x: 100, y: 100)

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .overlay {
                Text(expense.name + "\(expense.price)" + ViewModel().currency)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
            }
            .position(location)
            .gesture(
                DragGesture( minimumDistance: 25, coordinateSpace: .local)
                    .updating($locationState) { currentState, pastState, transaction in
                        pastState = currentState.location
                        transaction.animation = .easeInOut
                        
                    }
                
                    .onChanged { state in
                        withAnimation {
                            location = state.location
                        }
                    }
                    .onChanged { state in
                        
                        withAnimation {
                            location = state.location
                        }
                    }
                    
            )
            .draggable(expense)
    }
}

//#Preview {
//    ExpenseRectangleView()
//}
