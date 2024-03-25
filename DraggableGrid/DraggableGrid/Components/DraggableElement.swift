//
//  DraggableElement.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/03/2024.
//

import Foundation
import SwiftUI

struct DraggableElement<T: Identifiable>: View where T.ID == String {
    @EnvironmentObject var model: DraggableGridModel<T>
    
    @State private var offset: CGSize = .zero
    @State private var active: Bool = false
    
    let element: T
    let content: (() -> any View)
    
    private var onSortChange: ((DraggableGridSortFinishResult) -> Void)?
    
    init(element: T, content: @escaping (() -> any View)) {
        self.element = element
        self.content = content
    }
    
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
                offset = value.translation
                
                if let location = model.getLocation(for: element) {
                    let midX = location.midX + value.translation.width
                    let midY = location.midY + value.translation.height
                    let point = CGPoint(x: midX, y: midY)
                    
                    model.sort(element: element, point: point)
                }
            }
            .onEnded { value in
                model.finishSort { newPosition in
                    onSortChange?(newPosition)
                }
                
                withAnimation {
                    offset = .zero
                }

            }
        
        return longPressGesture.sequenced(before: dragGesture)
    }
}

extension DraggableElement {
    func onSortChange(_ onSortChange: @escaping (DraggableGridSortFinishResult) -> Void) -> DraggableElement {
        var view = self
        view.onSortChange = onSortChange
        
        return view
    }
}
