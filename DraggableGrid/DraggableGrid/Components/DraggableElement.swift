//
//  DraggableElement.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/03/2024.
//

import Foundation
import SwiftUI

struct DraggableElement: View {
    @EnvironmentObject var model: DraggableGridModel
    
    @State private var offset: CGSize = .zero
    @State private var active: Bool = false
    
    let element: DraggableElementWrapper
    let content: (() -> any View)
    
    var body: some View {
        ZStack {
            AnyView(content())
                .opacity(model.draggableElement?.id == element.id || active ? 1 : 0)
        }
        .contentShape(Rectangle())
        .offset(offset)
        .gesture(dragGesture())
        .onLongPressGesture(perform: { }) { value in
            active = value
        }
    }
    
    private func dragGesture() -> some Gesture {
        let longPressGesture = LongPressGesture()
            .onChanged { value in
                model.draggableElement = nil
            }
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .named("grid"))
            .onChanged { value in
                model.draggableElement = element
                offset = value.translation
                
                if let location = model.getLocation(for: element) {
                    let midX = location.midX + value.translation.width
                    let midY = location.midY + value.translation.height
                    let point = CGPoint(x: midX, y: midY)
                    
                    model.sort(element: element, point: point)
                }
            }
            .onEnded { value in
                withAnimation {
                    model.draggableElement = nil
                    offset = .zero
                }

            }
        
        return longPressGesture.sequenced(before: dragGesture)
    }
}
