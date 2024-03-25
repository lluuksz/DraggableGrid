//
//  DraggableGrid.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/01/2024.
//

import SwiftUI

struct DraggableGrid<T: Identifiable>: View where T.ID == String {
    @Namespace var namespace
    @ObservedObject private var model: DraggableGridModel<T>
    
    private let columns: Int
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    
    private var content: ((T) -> any View)?
    private var draggableContent: ((T) -> any View)?
    private var placeholder: (() -> any View)?
    private var onSortChange: ((DraggableGridSortFinishResult) -> Void)?
    
    init(
        columns: Int,
        columnSpacing: CGFloat,
        rowSpacing: CGFloat,
        list: [T]) {
            self.columns = columns
            self.columnSpacing = columnSpacing
            self.rowSpacing = rowSpacing
            self.model = DraggableGridModel<T>()
            self.model.setElements(elements: list)
    }
    
    var body: some View {
        ZStack {
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: model.elements1) { element, index in
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
            
            Grid(columns: columns, columnSpacing: columnSpacing, rowSpacing: rowSpacing, list: model.elements2) { element, index in
                if let draggableContent {
                    DraggableElement(element: element) {
                        draggableContent(element)
                    }
                    .onSortChange { newPosition in
                        onSortChange?(newPosition)
                    }
                    #if TEST
                    .accessibilityIdentifier("DraggableGridDraggableElement\(index)")
                    .accessibilityLabel(Text("DraggableGridDraggableElement\(element.id)"))
                    #endif
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
    
    var model = DraggableGridModel<DraggableElementWrapper>()
    model.setElements(elements: elements)
    
    return DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, list: elements)
}

extension DraggableGrid {
    func content(_ content: @escaping (T) -> any View) -> DraggableGrid {
        var view = self
        view.content = content
        
        return view
    }
    
    func draggableContent(_ draggableContent: @escaping (T) -> any View) -> DraggableGrid {
        var view = self
        view.draggableContent = draggableContent
        
        return view
    }
    
    func placeholder(_ placeholder: @escaping () -> any View) -> DraggableGrid {
        var view = self
        view.placeholder = placeholder
        
        return view
    }
    
    func onSortChange(_ onSortChange: @escaping (DraggableGridSortFinishResult) -> Void) -> DraggableGrid {
        var view = self
        view.onSortChange = onSortChange
        
        return view
    }
}
