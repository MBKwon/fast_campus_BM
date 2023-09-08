//
//  ControlExtension.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/22.
//

import UIKit

extension UIControl {
    @discardableResult
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) -> Self {
        self.addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
        return self
    }
}
