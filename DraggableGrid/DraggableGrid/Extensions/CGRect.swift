//
//  CGRect.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/03/2024.
//

import Foundation

extension CGRect {
    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
    }
}
