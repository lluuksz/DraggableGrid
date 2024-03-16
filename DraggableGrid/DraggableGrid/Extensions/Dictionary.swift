//
//  Dictionary.swift
//  DraggableGrid
//
//  Created by Łukasz Łuczak on 16/03/2024.
//

import Foundation

extension Dictionary where Key == Int, Value == CGRect {
    func firstMatch(point: CGPoint, ratio: CGFloat) -> Element? {
        first(where: { abs($0.value.center.x - point.x) < ratio && abs($0.value.center.y - point.y) < ratio })
    }
}
