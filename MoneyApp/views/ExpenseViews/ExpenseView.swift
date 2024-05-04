//
//  ExpenseView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 27/04/2024.
//

import SwiftUI

struct ExpenseView: View {
    @EnvironmentObject var vm: ViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var expense: Expense
    var body: some View {
        NavigationView {
            NavigationLink(destination: EditExpenseView(expense: $expense)) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .overlay {
                        HStack {
                            Text(expense.timestamp.formatted())
                            Spacer()
                            Text("\(Int(expense.price))" + "💰")
                        }
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .padding(.horizontal)
                    }
                    .foregroundStyle(.gray.opacity(0.2))
            }
        }
    }
    
}


//#Preview {
//    ExpenseView(, expense: $Expen)
//}



