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
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var expenses: [Expense]
    
    let bubble: Bubble
    
    var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    @EnvironmentObject var vm: ViewModel
    
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
    
    var sumOfExpenses: Int {
        guard let num = accumulatedGraph.last?.price else { return 0 }
        return Int(num)
    }
    
    var accumulatedGraph: [Expense] {
        var array: [Expense] = []
        
        var expenseSum = 0.0
        
        filteredAndSortedExpenses(predicate: {$0.timestamp < $1.timestamp}).forEach { expense in
            let newPrice = expense.price + expenseSum
            
            array.append(Expense(price: newPrice, timestamp: expense.timestamp))
            
            expenseSum += expense.price
        }
        
        
        array.insert(Expense(price: 0, timestamp: firstOfMonth), at: 0)
        
        return array
    }
    var endDate: Date {
        Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray.opacity(0.1))
                        .shadow(radius: 3, x: 3, y: 3)
                    if vm.state == .working {
                        ProgressView()
                    } else if expenses.isEmpty {
                        Text("No data to display").font(.headline).foregroundStyle(textColor)
                    }
                    else {
                        VStack(alignment: .leading) {
                            Text("January")
                                .font(.title3).bold()
                                .foregroundStyle(textColor)
                            
                            Text("\(sumOfExpenses)💰")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(textColor)
                            
                            Chart(accumulatedGraph) { data in
                                LineMark(x: .value("date", data.timestamp), y: .value("spent", data.price))
                                    .interpolationMethod(.cardinal)
                                    .lineStyle(.init(lineWidth: 2))
                            }
                            .chartYScale(domain: 0...(sumOfExpenses)*4/3)
                            .chartXScale(domain: firstOfMonth ... endDate)
                            .chartXAxis {
                                AxisMarks(preset: .extended, values: .stride (by: .day)) { value in
                                    AxisValueLabel(format: .dateTime.day())
                                }
                            }
                            
                        }
                        .padding()
                    }
                    
                    
                }
                .frame(height: 250)
                .padding()
                
                VStack {
                    ForEach(filteredAndSortedExpenses(predicate: {$0.timestamp > $1.timestamp })) { expense in
                        if let bindingExpense = $expenses.first(where: {$0.id == expense.id}) 
                        {
                            ExpenseView(expense: bindingExpense, expenses: $expenses)
                                .frame(height: 50)
                                .environmentObject(vm)
                        }
                    }
                }.padding()
            }
        }
        .navigationTitle(bubble.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(textColor)
                }
            }
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


//#Preview {
//    NavigationStack {
//        DataView(expenses: $vm.expensesInBubbles, bubble: Bubble(name: "Bubble"))
//            .navigationTitle("Food/drinks")
//    }
//}
