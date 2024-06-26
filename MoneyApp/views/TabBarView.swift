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
                DataView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                    }
                    .environmentObject(vm)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                    }
                    .environmentObject(vm)
            }.task {
                await vm.fetchBubbles()
                vm.fetchAllExpenses()
            }
        
    }
    
}

#Preview {
    TabBarView()
}
