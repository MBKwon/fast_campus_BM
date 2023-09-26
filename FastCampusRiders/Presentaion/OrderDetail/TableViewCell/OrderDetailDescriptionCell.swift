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
    
    private var dealInfo: OrderDetailInfo?
}

extension OrderDetailDescriptionCell {
    func bindActionButton(_ action: @escaping (OrderDetailInfo) -> Void) {
        self.delivaryButton.addAction({ [weak self] in
            guard let dealInfo = self?.dealInfo else { return }
            action(dealInfo)
        })
    }
    
    func updateUI(with dealInfo: OrderDetailInfo) {
        self.dealInfo = dealInfo
        
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
        
        let enabledColor = UIColor(red: 0.157, green: 0.761, blue: 0.737, alpha: 1)
        let disabledColor = UIColor.lightGray
        switch dealInfo.status {
        case .pending:
            self.delivaryButtonTitle.text = "배차 요청"
            self.delivaryButton.backgroundColor = enabledColor
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
            self.delivaryButtonTitle.text = "전달 완료"
            self.delivaryButton.backgroundColor = enabledColor
        case .completed:
            self.estimatedTimeLabel.text = nil
            self.currentStatusLabel.text = "배달완료"
            self.delivaryButtonTitle.text = "배달 완료"
            self.delivaryButton.backgroundColor = disabledColor
        }
    }
}
