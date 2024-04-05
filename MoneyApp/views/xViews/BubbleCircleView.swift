//
//  CtgryCircleView.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI

struct BubbleCircleView: View {
    @GestureState var locationState = CGPoint(x: 100, y: 100)
    @State var location = CGPoint(x: 100, y: 100)
    
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
        }
            
        
    }
    
    
}


//#Preview {
//    CtgryCircleView(category: _)
//}
