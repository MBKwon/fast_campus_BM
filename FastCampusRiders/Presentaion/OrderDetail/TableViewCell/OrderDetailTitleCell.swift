//
//  OrderDetailTitleCell.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/26.
//

import UIKit

class OrderDetailTitleCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImageView: UIImageView!
    
    static let cellIdentifier = "OrderDetailTitleCell"
}

extension OrderDetailTitleCell {
    func updateUI(with text: String, isFolded: Bool,
                  color: UIColor = .black) {
        self.titleLabel.text = text
        self.titleLabel.textColor = color

        if isFolded {
            self.arrowImageView.image = UIImage(named: "arrow_folded")
        } else {
            self.arrowImageView.image = UIImage(named: "arrow_unfolded")
        }
    }
}

