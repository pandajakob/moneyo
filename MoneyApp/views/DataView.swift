//
//  CategoryView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import SwiftUI
import Charts


extension Date {
    
}

struct DataView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var rotateArrow = true
    var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var expenses: [Expense]
    
    var sum: Int {
        var sum = 0.0
        expenses.forEach { expense in
            sum += expense.price
        }
        return Int(sum)
    }
    
    var firstOfMonth: Date {
        let calendar = Calendar.current
        var month = calendar.dateComponents([.month, .year], from: Date())
        month.day = 1
        
        return calendar.date(from: month) ?? Date()
    }
    
    func filteredAndSortedExpenses(predicate: (Expense, Expense) -> Bool) -> [Expense] {
        expenses
        .filter({$0.timestamp >= firstOfMonth })
        .sorted(by: predicate)
    }
    
    var accumulatedGraph: [Expense] {
        var array: [Expense] = []
        
        var expenseSum = 0.0
    
        filteredAndSortedExpenses(predicate: {$0.timestamp < $1.timestamp}).forEach { expense in
            let newPrice = expense.price + expenseSum
            
            array.append(Expense(price: newPrice, timestamp: expense.timestamp))
            
            expenseSum += expense.price
        }
        
        
//        array.insert(Expense(price: 0, timestamp: firstOfMonth), at: 0)

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
                        .foregroundStyle(textColor)
                    
                    Text("\(sum)💰")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(textColor)
                    
                    Chart(accumulatedGraph) { data in
                        LineMark(x: .value("date", data.timestamp), y: .value("spent", data.price))
                            .foregroundStyle(.orange)
                            .interpolationMethod(.cardinal)
                            .lineStyle(.init(lineWidth: 2))
                    }
                    .chartYScale(domain: 0...sum*4/3)
//                    .chartXAxis {
//                        AxisMarks(preset: .extended, values: .stride (by: .day)) { value in
////                            AxisValueLabel(format: .dateTime.day())
//                        }
//                    }
                    
                }
                .padding()
                
                
            }
            .frame(height: 250)
            .padding()
            
            VStack {
                
                ForEach(filteredAndSortedExpenses(predicate: {$0.timestamp > $1.timestamp })) { expense in
                    NavigationLink(destination: EditExpenseView(expense: expense)) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 50)
                            .overlay {
                                HStack {
                                    Text(expense.timestamp.formatted())
                                    Spacer()
                                    Text("\(Int(expense.price))" + "💰")
                                }
                                .foregroundStyle(textColor)                                    .font(.subheadline).fontWeight(.medium)
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
                    Image(systemName: "arrow.up")
                        .foregroundStyle(textColor)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DataView(expenses: [
            Expense(price: 100, timestamp: Date().addingTimeInterval(-86400)),
            
            
            Expense(price: 230, timestamp: Date().addingTimeInterval(-1045600)),

            Expense(price: 400, timestamp: Date().addingTimeInterval(-259200)),
            
            Expense(price: 200, timestamp: Date().addingTimeInterval(-545600)),
            
            Expense(price: 450, timestamp: Date().addingTimeInterval(-845600)),
            Expense(price: 100, timestamp: Date().addingTimeInterval(-172800)),

            
        ])
        
        .navigationTitle("Food/drinks")
    }
}
