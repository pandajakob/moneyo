//
//  AddBubbleView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 05/04/2024.
//

import SwiftUI

struct AddBubbleView: View {
    
    typealias CreateAction = (Bubble) async throws -> Void
    var createAction: CreateAction
    
    @State private var bubble: Bubble = Bubble(name: "")
    @FocusState var isFocused
    @State var bubbleColor: BubbleColors = BubbleColors.red
    @State private var state = FormState.idle
    
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
                            .onChange(of: bubbleColor) {
                            }
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
                        
                        createBubble()
                        if state == .working {
                            ProgressView()
                        } else {
                            Text("create data")
                        }
                    }
                
                label: {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 110, height: 55)
                            .shadow(radius: 3, x: 3, y: 3)
                            .overlay {
                                Image(systemName: "plus").foregroundStyle(.white)
                            }
                        
                    }.disabled(!formIsValid)
                        .padding(.vertical)
                        .padding(.vertical)
                    
                } .alert("Cannot Create data", isPresented: $state.isError, actions: {}) {
                    Text("Sorry, something went wrong.")
                }
                
            }
            .padding()
            .navigationTitle("New Bubble")
            
        }
        
    }
    private func createBubble() {
        Task {
            state = .working
            do {
                try await createAction(bubble)
                dismiss()
            }
            catch {
                print("Cannot create post: \(error)")
                state = .error
                
            }
            
        }
    }
    
    
}
private extension AddBubbleView {
    enum FormState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else { return }
                self = .idle
            }
        }
    }
}

//#Preview {
//    AddBubbleView()
//}
