//
//  OrderDetailContactCell.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/26.
//

import UIKit

class OrderDetailContactCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    @IBOutlet private weak var contactButton: UIButton!
    
    static let cellIdentifier = "OrderDetailContactCell"
}

extension OrderDetailContactCell {
    func updateUI(with locationInfo: LocationDetailInfo, color: UIColor = .black) {
        self.titleLabel.text = locationInfo.locationName
        self.addressLabel.text = locationInfo.address
        self.contactButton
            .setTitle(locationInfo.phoneNumber, state: .normal)
            .setTitleColor(color, state: .normal)
            .addAction {
                if let callURL = URL(string: "tel:\(locationInfo.phoneNumber)") {
                    UIApplication.shared.open(callURL)
                }
            }
        
        self.contactButton.layer.borderWidth = 1
        self.contactButton.layer.borderColor = color.cgColor
        self.contactButton.layer.cornerRadius = 5
        
        let callIconImage = UIImage(named: "icon_call_button")?.withRenderingMode(.alwaysTemplate)
        self.contactButton.setImage(callIconImage, for: .normal)
        self.contactButton.tintColor = color
    }
}
