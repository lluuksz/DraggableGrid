//
//  DraggableGridModel.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/03/2024.
//

import Foundation
import SwiftUI

struct DraggableGridSortFinishResult {
    let oldPosition: Int
    let newPosition: Int
}

class DraggableGridModel<T: Identifiable>: ObservableObject {
    
    typealias SortFinish = (DraggableGridSortFinishResult) -> Void
    
    @Published private(set) var elements1: [T] = []
    @Published private(set) var elements2: [T] = []
    @Published var draggableElement: T?
    
    private let ratio: CGFloat = 15
    
    private var oldPosition: Int?
    private var newPosition: Int?
    private var locations: [Int:CGRect] = [:]
    
    func setElements(elements: [T]) {
        self.elements1 = elements
        self.elements2 = elements
    }
    
    func saveLocation(element: T, rect: CGRect) {
        guard let index = elements1.firstIndex(where: { $0.id == element.id }) else { return }
        
        if locations[index] == nil {
            locations[index] = rect
        }
    }
    
    func getLocation(for element: T) -> CGRect? {
        guard let index = elements2.firstIndex(where: { $0.id == element.id }) else { return nil }
        
        return locations[index]
    }
    
    func sort(element: T, point: CGPoint) {
        draggableElement = element
        
        guard let index = elements1.firstIndex(where: { $0.id == element.id }) else { return }
        guard let newLocation = locations.firstMatch(point: point, ratio: ratio) else { return }
        guard newLocation.key != index else { return }
        
        if oldPosition == nil {
            oldPosition = index
        }
        
        newPosition = newLocation.key

        withAnimation {
            elements1.sort(oldPosition: index, newPosition: newLocation.key)
        }
    }
    
    func finishSort(completion: SortFinish) {
        defer {
            oldPosition = nil
            newPosition = nil
            draggableElement = nil
        }
        
        guard let oldPosition else { return }
        guard let newPosition else { return }
        
        let result = DraggableGridSortFinishResult(oldPosition: oldPosition, newPosition: newPosition)
        
        completion(result)
    }
    
}
