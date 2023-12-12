//
//  OrderDetailMemoCell.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/26.
//

import UIKit

class OrderDetailMemoCell: UITableViewCell {
    @IBOutlet private weak var memoLabel: UILabel!
    
    static let cellIdentifier = "OrderDetailMemoCell"
}

extension OrderDetailMemoCell {
    func updateUI(with memo: String) {
        self.memoLabel.text = memo
    }
}
