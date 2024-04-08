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
    
    var frame: CGFloat {
        let screenArea = maxWidth*maxHeigth
        var sum = 0.0
        
        vm.bubbles.forEach({ b in
            sum += b.sumOfExpenses
        })
        
        let bubbleArea = screenArea * bubble.sumOfExpenses/sum
        let bubbleDiameter = sqrt(bubbleArea/Double.pi)*2
        
        //        print("bubbleSum: ", bubble.sumOfExpenses/sum)
        //        print("screenArea",screenArea)
        //        print("diameter", bubbleDiameter)
        //        print("area", bubbleArea)
        
        if bubbleDiameter > 80 {
            return CGFloat(bubbleDiameter)
        } else {
            return 80
        }
        
        
    }
    
    let bubble: Bubble
    
    @State var sheet = false
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationStack {
            Circle()
                .frame(width: frame, height: frame)
                .contextMenu {
                    Button("delete") {
                        
                    }
                }
                .overlay {
                    VStack {
                        Text(bubble.name)
                            .font(.headline)
                        Text("\(Int(bubble.sumOfExpenses))💰")
                            .font(.callout)
                    }
                    .foregroundStyle(.white)
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
                    DataView(bubble: bubble)
                }
        }.onAppear { loadLocations(bubble: bubble) }
        
        
        
        
        
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
