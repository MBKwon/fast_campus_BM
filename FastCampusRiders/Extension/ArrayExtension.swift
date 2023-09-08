//
//  ArrayExtension.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/14.
//

import Foundation

extension Array {
    subscript(safe index : Int) -> Element? {
        if 0 <= index && index < self.count {
            return self[index]
        }

        return nil
    }
}
