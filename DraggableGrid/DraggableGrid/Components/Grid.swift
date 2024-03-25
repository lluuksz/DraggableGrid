//
//  Grid.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/01/2024.
//

import SwiftUI

// Reference: https://www.swiftpal.io/articles/how-to-create-a-grid-view-in-swiftui-for-ios-13

typealias ElementType = Identifiable

struct Grid<Content: View, Element: ElementType>: View where Element.ID == String {
    
    struct MatrixItem: Identifiable {
        let id: String
        let element: Element
        let index: Int
        
        init(element: Element, index: Int) {
            self.id = element.id
            self.element = element
            self.index = index
        }
    }
    
    private let columns: Int
    private let columnSpacing: CGFloat
    private let rowSpacing: CGFloat
    private var matrix: [[MatrixItem]] = []
    private let content: (Element, Int) -> Content
    
    init(columns: Int, columnSpacing: CGFloat, rowSpacing: CGFloat, list: [Element], @ViewBuilder content: @escaping (Element, Int) -> Content) {
        self.columns = columns
        self.rowSpacing = rowSpacing
        self.columnSpacing = columnSpacing
        self.content = content
        self.setupList(list)
    }
    
    private mutating func setupList(_ list: [Element]) {
        var column = 0
        var columnIndex = 0
        
        for (index, element) in list.enumerated() {
            if columnIndex < columns {
                if columnIndex == 0 {
                    matrix.insert([MatrixItem(element: element, index: index)], at: column)
                    columnIndex += 1
                } else {
                    matrix[column].append(MatrixItem(element: element, index: index))
                    columnIndex += 1
                }
            } else {
                column += 1
                matrix.insert([MatrixItem(element: element, index: index)], at: column)
                columnIndex = 1
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: rowSpacing) {
            ForEach(0 ..< matrix.count, id: \.self) { i in
                HStack(spacing: columnSpacing) {
                    ForEach(matrix[i]) { element in
                        content(element.element, element.index)
                    }
                }
            }
        }
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
    
    return Grid(columns: 3, columnSpacing: 8, rowSpacing: 8, list: list) { element, _ in
        VStack(spacing: 8) {
            Image(systemName: "star")
            Text(element.text)
        }
        .padding()
        .border(Color.black)
    }
}

