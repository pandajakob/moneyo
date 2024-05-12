//
//  EditExpenseView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 09/04/2024.
//

import SwiftUI

struct EditExpenseView: View {
    @Binding var expense: Expense
    @EnvironmentObject var vm: ViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var expenses: [Expense]

    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section("Price") {
                        TextField("amount", value: $expense.price, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                    Section("Date") {
                        DatePicker("Date", selection: $expense.timestamp)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            withAnimation {
                                print("[editExpenseBiew] expense:", expense)
                                vm.deleteExpense(expense: expense)
                                expenses.removeAll(where: {$0.id == expense.id})
                                vm.expensesInBubbles.removeAll(where: {$0.id == expense.id})
                            }
                            dismiss()
                        } label: {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 120, height: 60)
                                .foregroundStyle(.red)
                                .padding()
                                .overlay {
                                    Text("delete").font(.headline).foregroundStyle(.white)
                                }
                        }
                        Spacer()
                        Button {
                            dismiss()
//                            if let index = vm.expensesInBubbles.firstIndex(where: {$0.id == expense.id}) {
//                                vm.expensesInBubbles[index].price =
//                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 120, height: 60)
                                .foregroundStyle(.blue)
                                .padding()
                                .overlay {
                                    Text("submit").font(.headline).foregroundStyle(.white)
                                }
                                
                        }
                    }
                }
            }
        }
        
        
    }
}


