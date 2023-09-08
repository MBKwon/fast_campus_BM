//
//  ButtonExtension.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/08.
//

import UIKit

extension UIButton {
    
    @discardableResult
    func setTitle(_ title: String, state: UIControl.State) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    func setTitleColor(_ color: UIColor, state: UIControl.State) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
}
