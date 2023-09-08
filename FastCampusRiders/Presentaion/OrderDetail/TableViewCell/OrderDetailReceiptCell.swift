//
//  OrderDetailReceiptCell.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/26.
//

import UIKit

class OrderDetailReceiptCell: UITableViewCell {
    @IBOutlet private weak var orderIdLabel: UILabel!
    @IBOutlet private weak var orderPriceTitleLabel: UILabel!
    @IBOutlet private weak var orderPriceLabel: UILabel!
    
    @IBOutlet private weak var orderItemListBGView: UIView!
    @IBOutlet private weak var orderItemListView: UIStackView!
    
    static let cellIdentifier = "OrderDetailReceiptCell"
}
