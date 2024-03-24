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
    private var draggableContent: ((DraggableElementWrapper) -> any View)?
    private var placeholder: (() -> any View)?
    private var onSortChange: ((DraggableGridModel.SortFinishResult) -> Void)?
    
    init(
        columns: Int,
        columnSpacing: CGFloat,
        rowSpacing: CGFloat,
        list: [DraggableElementWrapper]) {
            print("Init DraggableGrid")
            self.columns = columns
            self.columnSpacing = columnSpacing
            self.rowSpacing = rowSpacing
            self.model = DraggableGridModel()
            self.model.setElements(elements: list)
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
                if let draggableContent {
                    DraggableElement(element: element) {
                        draggableContent(element)
                    }
                    .onSortChange { newPosition in
                        onSortChange?(newPosition)
                    }
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
    model.setElements(elements: elements)
    
    return DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, list: [])
}

extension DraggableGrid {
    func content(_ content: @escaping (DraggableElementWrapper) -> any View) -> DraggableGrid {
        var view = self
        view.content = content
        
        return view
    }
    
    func draggableContent(_ draggableContent: @escaping (DraggableElementWrapper) -> any View) -> DraggableGrid {
        var view = self
        view.draggableContent = draggableContent
        
        return view
    }
    
    func placeholder(_ placeholder: @escaping () -> any View) -> DraggableGrid {
        var view = self
        view.placeholder = placeholder
        
        return view
    }
    
    func onSortChange(_ onSortChange: @escaping (DraggableGridModel.SortFinishResult) -> Void) -> DraggableGrid {
        var view = self
        view.onSortChange = onSortChange
        
        return view
    }
}
