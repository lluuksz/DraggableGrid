//
//  Bubble.swift
//  DraggableGrid
//
//  Created by lluuksz on 16/05/2024.
//

import Foundation

struct Bubble: Identifiable {
    let id = UUID().uuidString
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
        Bubble(name: "Bubble 7"),
        Bubble(name: "Bubble 8"),
        Bubble(name: "Bubble 9"),
        Bubble(name: "Bubble 10"),
        Bubble(name: "Bubble 11"),
        Bubble(name: "Bubble 12"),
        Bubble(name: "Bubble 13")
    ]
}
