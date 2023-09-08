//
//  IntExtension.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/15.
//

import Foundation

extension Int {
    var formattedNumber: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
