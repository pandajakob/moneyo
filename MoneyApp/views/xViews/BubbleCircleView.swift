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
    @State var location = CGPoint(x: UIScreen.main.bounds.width/2 ,
                                  y: UIScreen.main.bounds.width/2)
    
    var frame: CGFloat
    let bubble: Bubble
    
    @State var isMoving = false
    @State var sheet = false
    
    @EnvironmentObject var vm: ViewModel

    var body: some View {
        NavigationStack {
            Circle()
                .overlay {
                    Text(bubble.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                .frame(width: isMoving ? frame*2 : frame)
                .position(location)
                .gesture(
                    DragGesture( minimumDistance: 25, coordinateSpace: .local)
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
                                saveLocations()
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
        }.onAppear(perform: loadLocations)
            
        
    }
    func saveLocations() {
        let defaults = UserDefaults.standard
        let x: Double = location.x
        let y: Double = location.y
        defaults.set(x,forKey: "lx")
        defaults.set(y,forKey: "ly")
    }
    
    func loadLocations(){
        let defaults = UserDefaults.standard
        let x = defaults.double(forKey: "lx")
        let y = defaults.double(forKey: "ly")
        location = CGPoint(x: x, y: y)
      
        
    }
}


//#Preview {
//    CtgryCircleView(category: _)
//}
