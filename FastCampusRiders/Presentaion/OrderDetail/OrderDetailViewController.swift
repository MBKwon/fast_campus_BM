//
//  OrderDetailViewController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/15.
//

import Combine
import MBAkit
import UIKit

class OrderDetailViewController: UITableViewController {
    
    private(set) var viewInteractor = OrderDetailViewInteractor()
    private(set) var viewModel = OrderDetailViewModel()
    private(set) var cancellables = Set<AnyCancellable>()
    
    var orderID: Int64?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel(self.viewModel)
        
        if let orderID = self.orderID {
            self.updateDetailInfoView(with: orderID)
        } else {
            assertionFailure("orderID is nil")
        }
    }
}

extension OrderDetailViewController {
    func updateDetailInfoView(with orderID: Int64) {
        self.viewModel.handleMessage(.getOrderDetail(orderID: orderID))
    }
}

extension OrderDetailViewController: ViewControllerConfigurable {
    
    typealias VM = OrderDetailViewModel
    
    typealias I = OrderDetailInputMessage
    enum OrderDetailInputMessage: InputMessage {
        case getOrderDetail(orderID: Int64)
    }
    
    typealias O = OrderDetailOutputMessage
    enum OrderDetailOutputMessage: OutputMessage {
        case updateOrderDetail(orderDetailInfo: OrderDetailInfo)
    }
    
    func bindViewModel(_ viewModel: OrderDetailViewModel) {
        viewModel.outputSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: self.handleResult)
            .store(in: &self.cancellables)
    }
    
    func handleResult(_ result: Result<O, Error>) {
        result.fold {
            self.viewInteractor
                .handleMessage(self.convertToInteraction(from: $0))
        } failure: { error in
            print(error)
        }
    }
}

extension OrderDetailViewController: ViewContollerInteractable {
    
    typealias VI = OrderDetailViewInteractor
    
    typealias IM = OrderDetailInteractionMessage
    enum OrderDetailInteractionMessage: InteractionMessage {
        case updateDetailView(orderDetailInfo: OrderDetailInfo,
                              vc: OrderDetailViewController)
    }
    
    func convertToInteraction(from outputMessage: OrderDetailOutputMessage)
    -> OrderDetailInteractionMessage {
        switch outputMessage {
        case .updateOrderDetail(let orderDetailInfo):
            return .updateDetailView(orderDetailInfo: orderDetailInfo, vc: self)
        }
    }
}
