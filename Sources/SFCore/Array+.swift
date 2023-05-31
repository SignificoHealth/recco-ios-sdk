//
//  Array+.swift
//  
//
//  Created by Adrián R on 8/3/22.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    func first(count: Int) -> [Element] {
        let min = Swift.min(count, self.count)
        return Array(self[0..<min])
    }
}
