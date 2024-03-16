//
//  DraggableGridModel.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/03/2024.
//

import Foundation
import SwiftUI

class DraggableGridModel: ObservableObject {
    private enum C {
        static let ratio: CGFloat = 15
    }
    
    @Published private(set) var elements1: [DraggableElementWrapper] = []
    @Published private(set) var elements2: [DraggableElementWrapper] = []
    @Published var draggableElement: DraggableElementWrapper?
    
    private var newPosition: Int?
    private var locations: [Int:CGRect] = [:]
    
    func setElement(elements: [DraggableElementWrapper]) {
        self.elements1 = elements
        self.elements2 = elements
    }
    
    func saveLocation(element: DraggableElementWrapper, rect: CGRect) {
        guard let index = elements1.firstIndex(where: { $0.id == element.id }) else { return }
        
        if locations[index] == nil {
            locations[index] = rect
        }
    }
    
    func getLocation(for element: DraggableElementWrapper) -> CGRect? {
        guard let index = elements2.firstIndex(where: { $0.id == element.id }) else { return nil }
        
        return locations[index]
    }
    
    func sort(element: DraggableElementWrapper, point: CGPoint) {
        draggableElement = element
        
        guard let index = elements1.firstIndex(where: { $0.id == element.id }) else { return }
        guard let newLocation = locations.firstMatch(point: point, ratio: C.ratio) else { return }
        guard newLocation.key != index else { return }
        
        newPosition = newLocation.key
        let offset = index < newLocation.key ? newLocation.key + 1 : newLocation.key
        
        withAnimation {
            elements1.move(fromOffsets: IndexSet([index]), toOffset: offset)
        }
    }
    
    func finishSort(completion: (Int) -> Void) {
        defer {
            newPosition = nil
            draggableElement = nil
        }
        
        guard let newPosition else { return }
        
        completion(newPosition)
    }
}
