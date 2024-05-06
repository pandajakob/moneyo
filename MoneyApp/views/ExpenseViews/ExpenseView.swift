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
                    .foregroundStyle(AppColors().stringToColor(for: vm.bubbles.first(where: {$0.id == expense.bubbleId})?.color ?? ""))
            }
        }
    }
    
}


//#Preview {
//    ExpenseView(, expense: $Expen)
//}



