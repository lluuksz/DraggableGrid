//
//  DraggableGrid.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/01/2024.
//

import SwiftUI

struct DraggableGrid: View {
    @Namespace var namespace
    @State private var draggingElement: DraggableElementWrapper?
    @State private var offset: CGSize = .zero
    @ObservedObject private var model: DraggableGridModel
    
    private let columns: Int
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    
    private var content: ((DraggableElementWrapper) -> any View)?
    private var draggingContent: ((DraggableElementWrapper) -> any View)?
    private var placeholder: (() -> any View)?
    
    init(
        columns: Int,
        columnSpacing: CGFloat,
        rowSpacing: CGFloat,
        model: DraggableGridModel) {
            self.columns = columns
            self.columnSpacing = columnSpacing
            self.rowSpacing = rowSpacing
            self.model = model
    }
    
    var body: some View {
        ZStack {
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: model.elements1) { element in
                if model.draggableElement?.id == element.id {
                    if let placeholder {
                        AnyView(placeholder())
                            .matchedGeometryEffect(id: element.id, in: namespace)
                    }
                } else {
                    if let content {
                        AnyView(content(element))
                            .overlay(
                                GeometryReader { proxy -> Color in
                                    model.saveLocation(element: element, rect: proxy.frame(in: .named("grid")))
                                    
                                    return Color.clear
                                }
                            )
                            .matchedGeometryEffect(id: element.id, in: namespace)
                    }
                }
                
            }
            
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: model.elements2) { element in
                DraggableElement(element: element) {
                    ZStack {
                        Text(element.name)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.blue)
                }
            }
        }
        .coordinateSpace(name: "grid")
        .environmentObject(model)
    }
}

#Preview {
    let elements: [DraggableElementWrapper] = [
        DraggableElementWrapper(name: "Element 1"),
        DraggableElementWrapper(name: "Element 2"),
        DraggableElementWrapper(name: "Element 3"),
        DraggableElementWrapper(name: "Element 4")
    ]
    
    var model = DraggableGridModel()
    model.setElement(elements: elements)
    
    return DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, model: model)
}

extension DraggableGrid {
    func content(_ content: @escaping (DraggableElementWrapper) -> any View) -> DraggableGrid {
        var view = self
        view.content = content
        
        return view
    }
    
    func placeholder(_ placeholder: @escaping () -> any View) -> DraggableGrid {
        var view = self
        view.placeholder = placeholder
        
        return view
    }
}
