//
//  ContentView.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 15/01/2024.
//

import SwiftUI

extension DraggableElementWrapper {
    static let all: [DraggableElementWrapper] = [
        DraggableElementWrapper(name: "Bubble 1"),
        DraggableElementWrapper(name: "Bubble 2"),
        DraggableElementWrapper(name: "Bubble 3"),
        DraggableElementWrapper(name: "Bubble 4"),
        DraggableElementWrapper(name: "Bubble 5"),
        DraggableElementWrapper(name: "Bubble 6"),
        DraggableElementWrapper(name: "Bubble 7")
    ]
}

struct ContentView: View {
    @State private var list: [DraggableElementWrapper] = DraggableElementWrapper.all
    
    var body: some View {
        VStack {
            DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, list: list)
                .content { element in
                    Circle()
                        .fill(Color.green.opacity(0.5))
                        .frame(width: 100, height: 100)
                        .overlay(Text(element.name), alignment: .center)
                }
                .draggableContent { element in
                    Circle()
                        .fill(Color.blue.opacity(0.5))
                        .frame(width: 100, height: 100)
                }
                .placeholder {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 100, height: 100)
                }
                .onSortChange { result in
                    list.sort(oldPosition: result.oldPosition, newPosition: result.newPosition)
                }
        }
    }
}

#Preview {
    ContentView()
}
