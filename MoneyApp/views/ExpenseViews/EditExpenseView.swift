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

    var body: some View {
        NavigationStack {
            Form {
//                TextField("amount", value: $expense.price, formatter: NumberFormatter())
                Text("hello")
            }
        }
        
      
    }
}


