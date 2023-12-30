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

    private(set) var microBean: MicroBean<OrderListViewController, OrderListViewModel, OrderListViewInteractor>?
    private(set) var cancellables = Set<AnyCancellable>()

    enum SegueIdentifier {
        static let showLogin = "showLogin"
        static let goToOrderDetail = "goToOrderDetail"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.microBean = MicroBean(withVC: self,
                                   viewModel: OrderListViewModel(),
                                   viewInteractor: OrderListViewInteractor())

        self.bindCategoryEvent()
        self.updateData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.orderListView.numberOfRows(inSection: 0) > 0 {
            self.microBean?.handle(interactionMessage: .resumeTimer)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.orderListView.numberOfRows(inSection: 0) > 0 {
            self.microBean?.handle(interactionMessage: .suspendTimer)
        }
    }
}

extension OrderListViewController {
    
    private func updateData() {
        self.performSegue(withIdentifier: SegueIdentifier.showLogin, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OrderDetailViewController,
           let orderID = sender as? String {
            vc.set(orderID: orderID) 
        } else if let vc = segue.destination as? SSOViewController {
            vc.afterLoginBlock = {
                vc.dismiss(animated: true)
                self.microBean?.handle(inputMessage: .getOrderList)
                self.microBean?.handle(interactionMessage: .resumeTimer)
            }
        } else {
            assertionFailure("undefined order ID")
        }
    }
}

// MARK: - ViewControllerConfigurable
extension OrderListViewController: ViewControllerConfigurable {
    
    typealias VM = OrderListViewModel
    
    typealias I = OrderListInput
    enum OrderListInput: InputMessage {
        case getOrderList
    }
    
    typealias O = OrderListOutput
    enum OrderListOutput: OutputMessage {
        case updateOrderList(orderList: [OrderDetailInfo])
    }
    
    func bindCategoryEvent() {
        self.orderCategoryView
            .selectedItemSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedIndex in
                guard let self = self else { return }
                self.microBean?
                    .handle(interactionMessage: .selectIndex(index: selectedIndex, vc: self))
            }.store(in: &self.cancellables)
    }
}

// MARK: - ViewContollerInteractable
extension OrderListViewController: ViewContollerInteractable {
    
    typealias VI = OrderListViewInteractor
    
    typealias IM = OrderListIM
    enum OrderListIM: InteractionMessage {
        case updateOrderList(dataList: [OrderDetailInfo],
                             categoryView: FCStackView,
                             vc: OrderListViewController)
        
        case selectIndex(index: Int, vc: OrderListViewController)

        case suspendTimer
        case resumeTimer
    }
    
    func convertToInteraction(from outputMessage: OrderListOutput) -> OrderListIM {
        switch outputMessage {
        case .updateOrderList(let orderList):
            return .updateOrderList(dataList: orderList,
                                    categoryView: self.orderCategoryView,
                                    vc: self)
        }
    }
}
