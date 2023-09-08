//
//  OrderListTableViewCell.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/14.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {
    @IBOutlet private weak var deliveryTypeLabel: UILabel!
    @IBOutlet private weak var progressIndicatorLabel: UILabel!
    @IBOutlet private weak var storeNameLabel: UILabel!
    @IBOutlet private weak var storeAddressLabel: UILabel!
    
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var recommandationLabel: UILabel!
    
    static let cellIdentifier = "OrderListTableViewCell"
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.deliveryTypeLabel.text = nil
        self.progressIndicatorLabel.text = nil
        
        self.storeNameLabel.text = nil
        self.storeAddressLabel.text = nil
        
        self.priceLabel.text = nil
        self.distanceLabel.text = nil
        self.recommandationLabel.text = nil
    }
}

extension OrderListTableViewCell {
    func updateUI(with info: OrderDetailInfo) {
        self.deliveryTypeLabel.text = info.isSingleDelivery ? "단건 배달" : "함께 배달"
        
        self.storeNameLabel.text = info.storeInfo.name
        self.storeAddressLabel.text = info.storeInfo.address
        
        self.priceLabel.text = "\(info.price.formattedNumber) \(info.priceUnit)"
        self.distanceLabel.text = "\(info.distance.formattedNumber) m"
        self.recommandationLabel.text = info.isRecommended ? "추천" : nil
        
        switch info.status {
        case .pending:
            if info.cookingEstimatedTime > 0 {
                self.progressIndicatorLabel.text = "\(info.cookingEstimatedTime) 남음 / 조리중"
            } else {
                self.progressIndicatorLabel.text = "픽업 대기중 / 조리 완료"
            }
        case .delivering:
            self.progressIndicatorLabel.text = "배달중"
        case .completed:
            self.progressIndicatorLabel.text = "배달완료"
        }
    }
}
