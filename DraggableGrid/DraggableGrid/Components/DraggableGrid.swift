//
//  DraggableGrid.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/01/2024.
//

import SwiftUI

class DraggableGridModel<Element: ElementType> {
    @Published var elements: [Element] = []
}

struct DraggableGrid<Content: View, DraggingContent: View, Placeholder: View, Element: ElementType>: View where Element.ID == String {
    @State private var draggingElement: Element?
    
    private let columns: Int
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    private let list: [Element]
    private let content: (Element) -> Content
    private let draggingContent: (Element) -> DraggingContent
    private let placeholder: () -> Placeholder
    
    init(
        columns: Int,
        columnSpacing: CGFloat,
        rowSpacing: CGFloat,
        list: [Element],
        @ViewBuilder content: @escaping (Element) -> Content,
        @ViewBuilder draggingContent: @escaping (Element) -> DraggingContent,
        @ViewBuilder placeholder: @escaping () -> Placeholder) {
            
            self.columns = columns
            self.rowSpacing = rowSpacing
            self.columnSpacing = columnSpacing
            self.list = list
            self.content = content
            self.draggingContent = draggingContent
            self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack {
            
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: list) { element in
                if draggingElement?.id == element.id {
                    placeholder()
                } else {
                    content(element)
                }
            }
            
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: list) { element in
                DraggableElement(element: element, draggingElement: $draggingElement) {
                    draggingContent(element)
                }
            }
            
        }
        .coordinateSpace(name: "grid")
    }
}

struct DraggableElement<Content: View, Element: ElementType>: View {
    @State private var offset: CGSize = .zero
    let element: Element
    @Binding var draggingElement: Element?
    
    let content: () -> Content
    
    var body: some View {
        ZStack {
            content()
        }
        .offset(offset)
        .gesture(dragGesture())
    }
    
    private func dragGesture() -> some Gesture {
        let longPressGesture = LongPressGesture()
            .onChanged { _ in
                draggingElement = element
            }
            .onEnded { _ in
                draggingElement = nil
            }
        
        let dragGesture = DragGesture(minimumDistance: 0, coordinateSpace: .named("grid"))
            .onChanged { value in
                draggingElement = element
                offset = value.translation
            }
            .onEnded { value in
                draggingElement = nil
                offset = .zero
            }
        
        return longPressGesture.sequenced(before: dragGesture)
    }
}

#Preview {
    struct PreviewElement: Hashable & Identifiable {
        let id = UUID().uuidString
        let text: String
    }
    
    let list: [PreviewElement] = [
        PreviewElement(text: "Element 1"),
        PreviewElement(text: "Element 2"),
        PreviewElement(text: "Element 3"),
        PreviewElement(text: "Element 4")
    ]
    
    return DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, list: list, content: { element in
        VStack(spacing: 8) {
            Image(systemName: "star")
            Text(element.text)
        }
        .padding()
        .border(Color.black)
    }, draggingContent: { element in
        VStack(spacing: 8) {
            Image(systemName: "star")
            Text(element.text)
        }
        .padding()
        .background(Color.red)
        .border(Color.black)
    }, placeholder: {
        VStack(spacing: 8) {

        }
        .padding()
        .border(Color.green)
    })
}
