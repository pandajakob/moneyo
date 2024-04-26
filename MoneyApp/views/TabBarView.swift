//
//  TabView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 14/04/2024.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        TabView {          
            BubbleView()
                .tabItem {
                    Image(systemName: "bubbles.and.sparkles")
                }
                .environmentObject(vm)
            AddBubbleView(createAction: vm.makeCreateAction())
                .tabItem {
                    Image(systemName: "chart.bar")
                }
            EditExpenseView(expense: Expense(price: 100))
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
    
}

#Preview {
    TabBarView()
}
