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
                
                DataView(expenses: $vm.expensesInBubbles, bubble: Bubble(name: "All Expenses"))
                    .tabItem {
                        Image(systemName: "chart.bar")
                    }
                    .environmentObject(vm)
                
                BubbleView()
                    .tabItem {
                        Image(systemName: "gear")
                    }
                    .environmentObject(vm)
            }
        
    }
    
}

#Preview {
    TabBarView()
}
