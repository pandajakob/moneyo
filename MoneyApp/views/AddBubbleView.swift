//
//  AddBubbleView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import SwiftUI

struct AddBubbleView: View {
    @State private var bubble: Bubble = Bubble(name: "", expenses: [])
    @FocusState var isFocused
    @State var bubbleColor: BubbleColors = BubbleColors.red
    @EnvironmentObject var vm: ViewModel
    @Environment(\.dismiss) var dismiss
    
    var formIsValid: Bool {
        !bubble.name.isEmpty
    }
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Bubble name", text: $bubble.name)
                        .font(.headline)
                        .padding()
                        .frame(height: 55)
                        .focused($isFocused)
                        .onAppear {
                            isFocused.toggle()
                        }
                        .textFieldStyle(.plain)
                        .background(Color.black.opacity(0.1))
                        .clipShape(.buttonBorder)
                    
                    
                    Menu {
                        Picker("Color", selection: $bubbleColor) {
                            ForEach(BubbleColors.allCases, id: \.self) { color in
                                Image(systemName: "circle.fill")
                                    .tint(color.color)
                                    .tag(color)
                            }
                        }.pickerStyle(.palette)
                    } label: {
                        Image(systemName: "circle.fill")
                            .tint(bubbleColor.color)
                        
                    }
                    .padding(.horizontal)
                }
                HStack {
                    Spacer()
                    Button {
                        bubble.color = bubbleColor.rawValue
                        withAnimation {
                            vm.bubbles.append(bubble)
                        }
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 110, height: 55)
                            .shadow(radius: 3, x: 3, y: 3)
                            .overlay {
                                Image(systemName: "plus").foregroundStyle(.white)
                            }
                        
                    }.disabled(!formIsValid)
                        .padding(.vertical)
                        .padding(.vertical)

                }
                
            }
            .padding()
            .navigationTitle("New Bubble")
            
        }
        
    }
    
    
}

#Preview {
    AddBubbleView()
}
