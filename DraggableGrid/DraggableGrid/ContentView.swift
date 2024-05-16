//
//  ContentView.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 15/01/2024.
//

import SwiftUI

extension Bubble {
    static let all: [Bubble] = [
        Bubble(name: "Bubble 1"),
        Bubble(name: "Bubble 2"),
        Bubble(name: "Bubble 3"),
        Bubble(name: "Bubble 4"),
        Bubble(name: "Bubble 5"),
        Bubble(name: "Bubble 6"),
        Bubble(name: "Bubble 7"),
        Bubble(name: "Bubble 8"),
        Bubble(name: "Bubble 9"),
        Bubble(name: "Bubble 10"),
        Bubble(name: "Bubble 11"),
        Bubble(name: "Bubble 12"),
        Bubble(name: "Bubble 13")
    ]
}

struct ContentView: View {
    @State private var list: [Bubble] = Bubble.all
    
    var body: some View {
        VStack {
            DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, list: list)
                .content { element in
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 100, height: 100)
                        .overlay(BubbleText(text: element.name), alignment: .center)
                }
                .draggableContent { element in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 100, height: 100)
                }
                .placeholder {
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 100, height: 100)
                }
                .onSortChange { result in
                    list.sort(oldPosition: result.oldPosition, newPosition: result.newPosition)
                }
        }
    }
    
    struct BubbleText: View {
        let text: String
        
        var body: some View {
            Text(text)
                .foregroundColor(.accent)
                .bold()
        }
    }

}

#Preview {
    ContentView()
}
