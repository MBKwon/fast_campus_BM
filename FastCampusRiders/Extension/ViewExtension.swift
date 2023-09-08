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

extension UIView {
    class func swizzleMethod() {
        let originalSelector = #selector(hitTest)
        let swizzleSelector = #selector(myHitTest)

        guard let originMethod = class_getInstanceMethod(UIView.self, originalSelector),
              let swizzleMethod = class_getInstanceMethod(UIView.self, swizzleSelector)
        else { return }

        method_exchangeImplementations(originMethod, swizzleMethod)
    }

    @objc public func myHitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = self.myHitTest(point, with: event)
        if let myView = hitView, myView == self {
            print("Touch : \(myView)")
        }

        return hitView
    }
}
