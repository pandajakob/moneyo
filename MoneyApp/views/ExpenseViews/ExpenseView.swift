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
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(vm.expensesInBubbles) { expense in
                        NavigationLink(destination: EditExpenseView(expense: expense)) {
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
                    }.navigationTitle("Expenses")
                }.padding()
            }
        }
    }
}

#Preview {
    ExpenseView()
}
