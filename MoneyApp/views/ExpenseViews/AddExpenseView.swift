//
//  FormView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import SwiftUI

struct AddExpenseView: View {
    @State private var textField = ""
    @FocusState var isFocused
    
    @EnvironmentObject var vm: ViewModel
    
    var isValid: Bool {
        if Double(textField) != nil && textField.count < 8 {
            return true
        }
        return false
    }
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                TextField("999💰", text: $textField)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
            }
            .font(.title).bold()
            .scaledToFit()
            
            Button {
                guard let price = Double(textField) else { return }
                isFocused = false
                withAnimation {
                    textField.removeAll()
                    vm.createExpense(price: price)
                }
                
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        Image(systemName: "plus")
                            .bold()
                            .foregroundStyle(.accent)
                    }
                    .frame(width: 100, height: 50)
                    .foregroundStyle(isValid ? .gray : .gray.opacity(0.3))
            }.disabled(!isValid)
            
        }
        .onTapGesture {
        }
    }
}

#Preview {
    AddExpenseView()
}
