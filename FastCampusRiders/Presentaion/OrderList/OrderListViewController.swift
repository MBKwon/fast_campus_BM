//
//  OrderListViewController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/05.
//

import Combine
import MBAkit
import UIKit

final class OrderListViewController: UIViewController {

    @IBOutlet private weak var orderCategoryView: FCStackView!

    @IBOutlet weak var orderListView: UITableView!
    @IBOutlet weak var orderCategoryViewHeight: NSLayoutConstraint!
}
