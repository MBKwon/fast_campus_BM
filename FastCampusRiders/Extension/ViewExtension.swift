//
//  ViewExtension.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/15.
//

import UIKit

extension UIView {
    @discardableResult
    func setTag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
}
