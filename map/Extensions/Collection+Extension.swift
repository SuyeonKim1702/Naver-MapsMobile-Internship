//
//  Collection+Extension.swift
//  map
//
//  Created by USER on 2021/02/05.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
