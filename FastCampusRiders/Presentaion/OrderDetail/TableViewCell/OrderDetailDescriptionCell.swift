//
//  OrderDetailDescriptionCell.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/21.
//

import UIKit

class OrderDetailDescriptionCell: UITableViewCell {
    @IBOutlet private weak var priceLabel: UILabel!
    
    @IBOutlet private weak var departureAreaLabel: UILabel!
    @IBOutlet private weak var departureTitleLabel: UILabel!
    @IBOutlet private weak var departureAddressLabel: UILabel!
    
    @IBOutlet private weak var destinationAreaLabel: UILabel!
    @IBOutlet private weak var destinationAddressLabel: UILabel!
    
    @IBOutlet private weak var estimatedTimeLabel: UILabel!
    @IBOutlet private weak var currentStatusLabel: UILabel!
    
    @IBOutlet private weak var delivaryButton: UIButton!
    @IBOutlet private weak var delivaryButtonTitle: UILabel!
    
    @IBOutlet private weak var departureMilestone: UIView!
    @IBOutlet private weak var pickupMilestone: UIView!
    @IBOutlet private weak var delivaryMilestone: UIView!
    
    static let cellIdentifier = "OrderDetailDescriptionCell"
}

extension OrderDetailDescriptionCell {
    func updateUI(with dealInfo: OrderDetailInfo) {
        let pixel = 1 / UIScreen().scale
        self.departureMilestone.layer.borderWidth = pixel
        self.departureMilestone.layer.borderColor = UIColor.black.cgColor
        
        self.pickupMilestone.layer.borderWidth = pixel
        self.pickupMilestone.layer.borderColor = UIColor.black.cgColor
        
        self.delivaryMilestone.layer.borderWidth = pixel
        self.delivaryMilestone.layer.borderColor = UIColor.black.cgColor
        
        self.priceLabel.text = dealInfo.priceLabelText
        
        self.departureTitleLabel.text = dealInfo.storeInfo.name
        self.departureAreaLabel.text = dealInfo.storeInfo.areaName
        self.departureAddressLabel.text = dealInfo.storeInfo.address
        
        self.destinationAreaLabel.text = dealInfo.destinationInfo.areaName
        self.destinationAddressLabel.text = dealInfo.destinationInfo.address
        
        self.delivaryButton.layer.cornerRadius = 5.0
        
        switch dealInfo.status {
        case .pending:
            self.delivaryButtonTitle.text = "배차 요청"
            if dealInfo.cookingEstimatedTime > 0 {
                self.estimatedTimeLabel.text = "\(dealInfo.cookingEstimatedTime) 남음"
                self.currentStatusLabel.text = "조리중"
            } else {
                self.estimatedTimeLabel.text = nil
                self.currentStatusLabel.text = "픽업 대기중 / 조리 완료"
            }
        case .delivering:
            self.estimatedTimeLabel.text = nil
            self.currentStatusLabel.text = "배달중"
            self.delivaryButtonTitle.text = "배달 완료 요청"
        case .completed:
            self.estimatedTimeLabel.text = nil
            self.currentStatusLabel.text = "배달완료"
            self.delivaryButtonTitle.text = "배달 완료"
        }
    }
}
