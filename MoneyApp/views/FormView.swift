//
//  FormView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import SwiftUI

struct FormView: View {
    @State private var textField = ""
    @FocusState var isFocused
    
    @EnvironmentObject var vm: ViewModel
    
    var isValid: Bool {
        if Double(textField) != nil {
            return true
        }
        return false
        
    }
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                TextField("999", text: $textField)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                
                Text(vm.currency)
            }
            .foregroundStyle(.black)
            .font(.title).bold()
            .frame(width: 100)
            
            Button {
                guard let price = Double(textField) else { return }
                isFocused = false
                withAnimation {
                    textField.removeAll()
                    vm.expensesToAdd.append(Expense(price: price, name: ""))
                }
                
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .bold()
                    }
                    .frame(width: 100, height: 50)
            }.disabled(!isValid)
            
        }
        .onTapGesture {
            isFocused = false
            
        }
    }
}

#Preview {
    FormView()
}
