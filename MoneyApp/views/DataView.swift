//
//  CategoryView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import SwiftUI
import Charts

struct DataView: View {
    
    @Environment(\.dismiss) var dismiss
    let expenses: [Expense]
    
    private func maxExpense() -> Double {
        guard let expense = expenses.max(by: { $0.price < $1.price }) else { return 0 }
        return expense.price*1.5
    }
    var sum: Int {
        var sum = 0.0
        expenses.forEach { expense in
            sum += expense.price
        }
        return Int(sum)
    }
    
    var lastMonth: [Expense] {
        let array = expenses.filter { expense in
            Calendar.current.component(.month, from: expense.timestamp) == Calendar.current.component(.month, from: Date())
        }.sorted(by: {$0.timestamp < $1.timestamp})
        
        return array
    }
    
    var body: some View {
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray.opacity(0.1))
                        .shadow(radius: 3, x: 3, y: 3)
                    
                    VStack(alignment: .leading) {
                        Text("January")
                            .font(.title3).bold()
                            .foregroundStyle(.black)
                        
                        Text("\(sum)💰")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.black)
                        
                        Chart(lastMonth) { data in
                            LineMark(x: .value("date", Calendar.current.startOfDay(for: data.timestamp)), y: .value("spent", data.price))
                                .foregroundStyle(.orange)
                                .interpolationMethod(.cardinal)
                                .lineStyle(.init(lineWidth: 2))
                        }
                        .chartYScale(domain: 0...maxExpense())
                        .chartXAxis {
                            AxisMarks(preset: .extended, values: .stride (by: .day)) { value in
                                AxisValueLabel(format: .dateTime.day())
                            }
                        }
                        
                    }
                    .padding()
                    
                    
                }
                .frame(height: 250)
                .padding()
                
                VStack {
                    
                    ForEach(expenses) { expense in
                        NavigationLink(destination: EditExpenseView(expense: expense)) {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 50)
                                .overlay {
                                    HStack {
                                        Text(expense.timestamp.formatted())
                                        Spacer()
                                        Text("\(Int(expense.price))" + "💰")
                                    }
                                    .foregroundStyle(.black)
                                    .font(.subheadline).fontWeight(.medium)
                                    .padding(.horizontal)
                                }
                            
                                .foregroundStyle(.gray.opacity(0.2))
                        }
                    }
                }.padding()
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "arrow.down")
                            .foregroundStyle(.black)
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        DataView(expenses: [
            Expense(price: 100, timestamp: Date().addingTimeInterval(-86400)),
            
            Expense(price: 100, timestamp: Date().addingTimeInterval(-172800)),
            
            Expense(price: 400, timestamp: Date().addingTimeInterval(-259200)),
            
            Expense(price: 200, timestamp: Date().addingTimeInterval(-545600)),
            
            Expense(price: 450, timestamp: Date().addingTimeInterval(-845600)),
            
            Expense(price: 230, timestamp: Date().addingTimeInterval(-1045600)),
        ])
        
        .navigationTitle("Food/drinks")
    }
}
