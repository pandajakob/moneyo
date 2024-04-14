//
//  CtgryCircleView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct BubbleCircleView: View {
    @GestureState var locationState = CGPoint(x: 200, y: 200)
    let maxWidth = UIScreen.main.bounds.width
    let maxHeigth = UIScreen.main.bounds.height
    @State var location = CGPoint()
    
    @State var bubbleDeleteViewPresented = false
    
    
    
    let frame: CGFloat = 150
    
    let bubble: Bubble
    
    @State var sheet = false
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {
            Circle()
                .frame(width: frame, height: frame)
                .overlay {
                    VStack {
                        Text(bubble.name)
                            .font(.headline)
                        //                        Text("\(Int(bubble.sumOfExpenses))💰")
                            .font(.callout)
                    }
                    .foregroundStyle(.white)
                }
                .contextMenu {
                    Button {
                        
                    } label: {
                        HStack {
                            Text("edit")
                            Image(systemName: "square.and.pencil")
                        }
                    }
                    
                    Button {
                        bubbleDeleteViewPresented.toggle()
                    } label: {
                        HStack {
                            Text("delete")
                            Image(systemName: "trash")
                        }
                    }
                }
            
                .position(location)
            
                .gesture(
                    DragGesture( minimumDistance: 20, coordinateSpace: .local)
                        .updating($locationState) { currentState, pastState, transaction in
                            pastState = currentState.location
                            transaction.animation = .easeInOut
                            
                        }
                    
                        .onChanged { state in
                            withAnimation {
                                location = state.location
                            }
                        }
                        .onChanged { state in
                            
                            withAnimation {
                                location = state.location
                                saveLocations(bubble: bubble)
                            }
                        }
                )
            
            
                .onTapGesture {
                    withAnimation {
                        sheet.toggle()
                    }
                }
                .sheet(isPresented: $sheet) {
                    NavigationStack {
                            DataView(bubble: bubble)
                                .environmentObject(ViewModel())
                    }
                }
        }
        .onAppear {
            loadLocations(bubble: bubble)
        }
        
        .sheet(isPresented: $bubbleDeleteViewPresented, content: {
            VStack {
                Text("are you sure you want to delete \(bubble.name) and its associated expenses?")
                    .foregroundStyle(.black).font(.headline)
                    .padding()
                Button {
                    withAnimation {
                        vm.deleteBubble(bubble: bubble)
                        vm.bubbles.removeAll(where: {$0.id == bubble.id})
                        
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10).foregroundStyle(.red)
                        .overlay {
                            Text("yes").font(.headline)
                                .foregroundStyle(.white)
                        }
                        .frame(height: 50)
                        .padding()
                }
            }
            .presentationDetents([.height(225)])
        })
        
        
        
    }
    
    let defaults = UserDefaults.standard
    
    func saveLocations(bubble: Bubble) {
        let x: Double = location.x
        let y: Double = location.y
        
        defaults.set(x, forKey: bubble.id.uuidString + "x")
        defaults.set(y, forKey: bubble.id.uuidString + "y")
    }
    
    func loadLocations(bubble: Bubble) {
        let x = defaults.double(forKey: bubble.id.uuidString + "x")
        let y = defaults.double(forKey: bubble.id.uuidString + "y")
        
        location = CGPoint(x: x, y: y)
        
    }
}


//#Preview {
//    CtgryCircleView(category: _)
//}

//var frame: CGFloat {
//    let totalSum: Double = 20000
//    
//    let screenArea = maxWidth*maxHeigth
//        var bubbleArea: Double {
//            return screenArea * expenseSum/totalSum
//        }
//    
//    let bubbleDiameter = sqrt(bubbleArea/Double.pi)
//    
//            print("expenseSum: ", expenseSum)
//            print("bubbleSum: ", expenseSum/totalSum)
//            print("diameter", bubbleDiameter)
//            print("area", bubbleArea)
//    
//    if bubbleDiameter > 80 {
//        return CGFloat(bubbleDiameter)
//    } else {
//        return CGFloat(150)
//    }
//    
//}
