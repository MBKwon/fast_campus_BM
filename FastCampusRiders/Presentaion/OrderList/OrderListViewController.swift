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
    
    private(set) var viewModel = OrderListViewModel()
    private(set) var viewInteractor = OrderListViewInteractor()
    private(set) var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.bindViewModel(self.viewModel)
        self.updateData()
    }
    
    enum SegueIdentifier {
        static let goToOrderDetail = "goToOrderDetail"
    }
}

extension OrderListViewController {
    
    private func updateData() {
        self.viewModel.handleMessage(OrderListInput.getOrderList)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? OrderDetailViewController,
           let orderID = sender as? Int64 {
            vc.orderID = orderID
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
    
    func bindViewModel(_ viewModel: OrderListViewModel) {
        viewModel.outputSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.handleResult)
            .store(in: &self.cancellables)
        
        self.orderCategoryView
            .selectedItemSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedIndex in
                guard let self = self else { return }
                self.viewInteractor
                    .handleMessage(.selectIndex(index: selectedIndex,
                                                vc: self))
                
            }.store(in: &self.cancellables)
    }
    
    func handleResult(_ result: Result<OrderListOutput, Error>) {
        result
            .map(self.convertToInteraction(from:))
            .fold(success: self.viewInteractor.handleMessage, failure: { error in
                print(error.localizedDescription)
            })
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
