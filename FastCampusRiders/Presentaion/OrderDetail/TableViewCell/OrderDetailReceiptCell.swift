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

extension OrderDetailReceiptCell {
    func updateUI(with dealInfo: OrderDetailInfo) {
        self.orderItemListBGView.layer.borderColor = UIColor(white: 0.824, alpha: 1.0).cgColor
        self.orderItemListBGView.layer.borderWidth = 1.0
        self.orderItemListBGView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.orderItemListBGView.layer.cornerRadius = 10.0

        self.orderIdLabel.text = "\(dealInfo.id)"
        self.orderPriceTitleLabel.text = "금액"
        self.orderPriceLabel.text = dealInfo.priceLabelText

        self.orderItemListView.arrangedSubviews
            .forEach({ $0.removeFromSuperview() })

        dealInfo.itemList
            .map({ OrderDetailItemView(frame: .zero, with: $0) })
            .forEach(self.orderItemListView.addArrangedSubview(_:))
    }
}

private class OrderDetailItemView: UIView {
    static let viewHeight: CGFloat = 21.0

    private let itemNameLabel = UILabel()
    private let itemQuantityLabel = UILabel()
    private let itemPriceLabel = UILabel()

    fileprivate required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.itemQuantityLabel.translatesAutoresizingMaskIntoConstraints = false
        self.itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.itemNameLabel)
        self.addSubview(self.itemQuantityLabel)
        self.addSubview(self.itemPriceLabel)

        self.addConstraints([

            // related to itemNameLabel
            NSLayoutConstraint(item: self.itemNameLabel, attribute: .leading, relatedBy: .equal,
                               toItem: self, attribute: .leading,
                               multiplier: 1.0, constant: 20.0),
            NSLayoutConstraint(item: self.itemNameLabel, attribute: .width, relatedBy: .equal,
                               toItem: nil, attribute: .width,
                               multiplier: 1.0, constant: 157.0),
            NSLayoutConstraint(item: self.itemNameLabel, attribute: .height, relatedBy: .equal,
                               toItem: nil, attribute: .height,
                               multiplier: 1.0, constant: 32.0),

            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                               toItem: self.itemNameLabel, attribute: .top,
                               multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                               toItem: self.itemNameLabel, attribute: .bottom,
                               multiplier: 1.0, constant: 0.0),

            // related to itemQuantityLabel
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                               toItem: self.itemQuantityLabel, attribute: .top,
                               multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                               toItem: self.itemQuantityLabel, attribute: .bottom,
                               multiplier: 1.0, constant: 0.0),

            // related to itemPriceLabel
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal,
                               toItem: self.itemPriceLabel, attribute: .top,
                               multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal,
                               toItem: self.itemPriceLabel, attribute: .bottom,
                               multiplier: 1.0, constant: 0.0),

            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal,
                               toItem: self.itemPriceLabel, attribute: .trailing,
                               multiplier: 1.0, constant: 20.0),

            // related to margins of Labels
            NSLayoutConstraint(item: self.itemQuantityLabel, attribute: .leading, relatedBy: .equal,
                               toItem: self.itemNameLabel, attribute: .trailing,
                               multiplier: 1.0, constant: 11.0),

            NSLayoutConstraint(item: self.itemPriceLabel, attribute: .leading, relatedBy: .greaterThanOrEqual,
                               toItem: self.itemQuantityLabel, attribute: .trailing,
                               multiplier: 1.0, constant: 20.0)
        ])
    }

    convenience init(frame: CGRect, with itemInfo: ItemDetailInfo) {
        self.init(frame: frame)
        self.itemNameLabel.text = itemInfo.name
        self.itemNameLabel.textColor = UIColor(white: 0.188, alpha: 1.0)
        self.itemNameLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)

        self.itemQuantityLabel.text = "\(itemInfo.quantity)"
        self.itemQuantityLabel.textColor = UIColor(white: 0.188, alpha: 1.0)
        self.itemQuantityLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)

        self.itemPriceLabel.text =  itemInfo.priceLabelText
        self.itemPriceLabel.textColor = UIColor(white: 0.188, alpha: 1.0)
        self.itemPriceLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
    }
}
