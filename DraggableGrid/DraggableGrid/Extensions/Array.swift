//
//  Array.swift
//  DraggableGrid
//
//  Created by lluuksz on 24/03/2024.
//

import Foundation

extension Array {
    
    mutating func sort(oldPosition: Int, newPosition: Int) {
        let offset = oldPosition < newPosition ? newPosition + 1 : newPosition
        self.move(fromOffsets: IndexSet([oldPosition]), toOffset: offset)
    }
    
}
