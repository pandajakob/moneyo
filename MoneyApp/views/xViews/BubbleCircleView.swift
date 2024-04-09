//
//  CtgryCircleView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct BubbleCircleView: View {
    @GestureState var locationState = CGPoint(x: 100, y: 100)
    let maxWidth = UIScreen.main.bounds.width
    let maxHeigth = UIScreen.main.bounds.width
    @State var location = CGPoint(x: Double(UIScreen.main.bounds.width)/Double.random(in: 0.5...4) ,
                                  y: Double(UIScreen.main.bounds.width)/Double.random(in: 0.5...4))
    
    @State var bubbleDeleteViewPresented = false
    
    var frame: CGFloat {
        let screenArea = maxWidth*maxHeigth
        var sum = 0.0
        
        vm.bubbles.forEach({ b in
            //            sum += b.sumOfExpenses
        })
        
        //        let bubbleArea = screenArea * bubble.sumOfExpenses/sum
        //        let bubbleDiameter = sqrt(bubbleArea/Double.pi)*2
        
        //        print("bubbleSum: ", bubble.sumOfExpenses/sum)
        //        print("screenArea",screenArea)
        //        print("diameter", bubbleDiameter)
        //        print("area", bubbleArea)
        
        //        if bubbleDiameter > 80 {
        //            return CGFloat(bubbleDiameter)
        //        } else {
        //            return 80
        //        }
        return 150
        
        
    }
    
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
                        bubbleDeleteViewPresented.toggle()
                    } label: {
                        HStack {
                            Text("delete")
                            Image(systemName: "trash")
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        HStack {
                            Text("delete")
                            Image(systemName: "square.and.pencil")
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
                        DataView(expenses: vm.expensesInBubble)
                            .onAppear {
                                vm.fetchExpensesForBubble(bubble: bubble)
                            }
                            .navigationTitle(bubble.name)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "square.and.pencil")
                                            .foregroundStyle(.black)
                                    }
                                }
                               
                            }
                            
                    }
                    
                }
        }
        .onAppear { loadLocations(bubble: bubble)  }
        .sheet(isPresented: $bubbleDeleteViewPresented, content: {
            VStack {
                Text("are you sure you want to delete \(bubble.name) and its associated expenses?")
                    .foregroundStyle(.black).font(.headline)
                    .padding()
                Button {
                    vm.deleteBubble(bubble: bubble)
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
    
    func loadLocations(bubble: Bubble){
        let x = defaults.double(forKey: bubble.id.uuidString + "x")
        let y = defaults.double(forKey: bubble.id.uuidString + "y")
        
        location = CGPoint(x: x, y: y)
    }
}


//#Preview {
//    CtgryCircleView(category: _)
//}
