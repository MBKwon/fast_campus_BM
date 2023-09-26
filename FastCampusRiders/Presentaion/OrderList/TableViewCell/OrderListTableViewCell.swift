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
    private let timeWarningLayer = CAGradientLayer()

    private var existingOrderInfo: OrderDetailInfo?


    private var defaultColor: UIColor {
        return UIColor(red: 0.824, green: 0.824, blue: 0.824, alpha: 1)
    }
    private var highlightedColor: UIColor {
        return UIColor(red: 0.157, green: 0.761, blue: 0.737, alpha: 1)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.existingOrderInfo = nil

        self.deliveryTypeLabel.text = nil
        self.progressIndicatorLabel.text = nil
        
        self.storeNameLabel.text = nil
        self.storeAddressLabel.text = nil
        
        self.priceLabel.text = nil
        self.distanceLabel.text = nil
        self.recommandationLabel.text = nil

        self.timeWarningLayer.colors = nil
        self.timeWarningLayer.locations = nil
    }
}

extension OrderListTableViewCell {
    func updateUI(with info: OrderDetailInfo) {
        if self.existingOrderInfo != info {
            self.deliveryTypeLabel.text = info.isSingleDelivery ? "단건 배달" : "함께 배달"

            self.storeNameLabel.text = info.storeInfo.name
            self.storeAddressLabel.text = info.storeInfo.address

            self.priceLabel.text = "\(info.price.formattedNumber) \(info.priceUnit)"
            self.distanceLabel.text = "\(info.distance.formattedNumber) m"
            self.recommandationLabel.text = info.isRecommended ? "추천" : nil
            self.existingOrderInfo = info
        }

        self.updateOrderStatusUI(with: info)
    }

    private func updateOrderStatusUI(with info: OrderDetailInfo) {
        switch info.status {
        case .pending:
            if info.cookingEstimatedTime > 0 {
                self.progressIndicatorLabel.text = "\(info.cookingEstimatedTime) 남음 / 조리중"
            } else {
                self.progressIndicatorLabel.text = "픽업 대기중 / 조리 완료"
            }
            self.updateTimeRemaingUI(with: info)
        case .delivering:
            self.progressIndicatorLabel.text = "배달중"
            self.updateTimeRemaingUI(with: info)
        case .completed:
            self.progressIndicatorLabel.text = "배달완료"
        }
    }

    private func updateTimeRemaingUI(with info: OrderDetailInfo) {
        let timeLimit = FCConstants.deliveryTimeLimitation
        let timeRemaining = info.deadline.timeIntervalSince(info.registerd)
        let percentTime = (timeLimit - timeRemaining) / timeLimit

        if self.timeWarningLayer.superlayer == nil {
            self.timeWarningLayer.opacity = 0.8
            self.timeWarningLayer.startPoint = CGPoint(x: 0, y: 0.5)
            self.timeWarningLayer.endPoint = CGPoint(x: 1, y: 0.5)
            self.layer.insertSublayer(self.timeWarningLayer, at: 1)
        }

        if percentTime < 0.0 {
            self.timeWarningLayer.colors = [UIColor.white.cgColor, UIColor.red.cgColor]
            self.timeWarningLayer.locations = [0, 0]
        } else if percentTime <= 0.1 {
            self.timeWarningLayer.colors = [UIColor.white.cgColor, UIColor.yellow.cgColor]
            self.timeWarningLayer.locations = [0, 0.1]
        } else if info.cookingEstimatedTime > 0 {
            self.timeWarningLayer.colors = [UIColor.white.cgColor, 
                                            UIColor.white.cgColor, self.defaultColor.cgColor]
            self.timeWarningLayer.locations = [0, NSNumber(value: 1 - percentTime), 1]
        } else {
            self.timeWarningLayer.colors = [UIColor.white.cgColor,
                                            UIColor.white.cgColor, self.highlightedColor.cgColor]
            self.timeWarningLayer.locations = [0, NSNumber(value: 1 - percentTime), 1]
        }

        self.timeWarningLayer.frame = self.bounds
        self.timeWarningLayer.layoutIfNeeded()
    }
}
