//
//  CategoryView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import SwiftUI

struct DataView: View {
    let bubble: Bubble
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(bubble.expenses) { expense in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 45)
                        .overlay {
                            HStack {
                                Text(expense.name)
                                Spacer()
                                Text("\(Int(expense.price))" + "💰")
                            }
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding(.horizontal)
                        }
                        .padding()
                        .foregroundStyle(.black)
                }
            }
            .navigationTitle(bubble.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "gear")
                }
            }
        }
        
        
    }
}
//b
