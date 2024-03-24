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
                    ZStack {
                        Text(element.name)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.red)
                }
                .draggableContent { element in
                    ZStack {
                        Text(element.name)
                    }
                    .frame(width: 100, height: 100)
                    .background(Color.blue)
                }
                .placeholder {
                    Rectangle()
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.3))
                }
                .onSortChange { result in 
                    let offset = result.oldPosition < result.newPosition ? result.newPosition + 1 : result.newPosition
                    list.move(fromOffsets: IndexSet([result.oldPosition]), toOffset: offset)
                }
        }
    }
}

#Preview {
    ContentView()
}
