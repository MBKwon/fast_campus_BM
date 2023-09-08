//
//  FCStackView.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/08.
//

import Combine
import UIKit

class FCStackView: UIStackView {
    
    var selectedItemSubject = PassthroughSubject<Int, Never>()
    private var itemList: [FCStackItem] = []
    private struct FCStackItem {
        let title: String
        let itemTag: Int
    }
}

extension FCStackView {
    func addButton(title: String, itemTag: Int) {
        self.addArrangedSubview(UIButton(type: .custom)
            .setTitleColor(.systemGray, state: .normal)
            .setTitle(title, state: .normal)
            .setTag(itemTag)
            .addAction { [weak self] in
                self?.updateStackView(with: itemTag)
                self?.selectedItemSubject.send(itemTag)
            })
        
        let newItem = FCStackItem(title: title, itemTag: itemTag)
        
        self.itemList.append(newItem)
        if self.itemList.count == 1 {
            self.updateStackView(with: itemTag)
        }
    }
    
    func removeButton(with itemTag: Int) {
        self.itemList.removeAll { $0.itemTag == itemTag }
        self.viewWithTag(itemTag)
            .flatMap(self.removeArrangedSubview(_:))
    }
}

extension FCStackView {
    private func updateStackView(with itemTag: Int) {
        self.arrangedSubviews
            .forEach {
                guard let button = $0 as? UIButton else { return }
                if button.tag == itemTag {
                    button.setTitleColor(.systemBlue, state: .normal)
                } else {
                    button.setTitleColor(.systemGray, state: .normal)
                }
            }
    }
}
