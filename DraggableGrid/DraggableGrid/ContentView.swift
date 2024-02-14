//
//  ContentView.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 15/01/2024.
//

import SwiftUI

struct Bubble: Hashable & Identifiable {
    let id: String = UUID().uuidString
    let name: String
}

extension Bubble {
    static let all: [Bubble] = [
        Bubble(name: "Bubble 1"),
        Bubble(name: "Bubble 2"),
        Bubble(name: "Bubble 3"),
        Bubble(name: "Bubble 4"),
        Bubble(name: "Bubble 5"),
        Bubble(name: "Bubble 6"),
        Bubble(name: "Bubble 7")
    ]
}

struct ContentView: View {
    @ObservedObject var model = DraggableGridModel<Bubble>()
    
    init() {
        model.setElement(elements: Bubble.all)
    }
    
    var body: some View {
        VStack {
            DraggableGrid(columns: 3, columnSpacing: 8, rowSpacing: 8, model: model) { element in
                VStack {
                    Image(systemName: "star.fill")
                    Text(element.name)
                }
                .frame(width: 100, height: 100, alignment: .top)
                .background(Color.red)
                
            } draggingContent: { (element) in
                VStack {
                    Image(systemName: "star.fill")
                }
                .frame(width: 100, height: 100, alignment: .top)
                .background(Color.blue)
                
            } placeholder: {
                VStack {
                    
                }
                .frame(width: 100, height: 100, alignment: .top)
                .background(Color.gray)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
