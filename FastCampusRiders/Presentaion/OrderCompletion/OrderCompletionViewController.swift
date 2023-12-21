//
//  OrderCompletionViewController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/09/26.
//

import Combine
import MBAkit
import UIKit

class OrderCompletionViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    private(set) var microBean: MicroBean<OrderCompletionViewController,
                                          OrderCompletionViewModel,
                                          OrderCompletionViewInteractor>?

    private(set) var orderID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.microBean = MicroBean(withVC: self,
                                   viewModel: OrderCompletionViewModel(),
                                   viewInteractor: OrderCompletionViewInteractor())
    }
}

extension OrderCompletionViewController {
    func set(orderID: String) {
        self.orderID = orderID
    }

    @IBAction private func touchAddingPhoto() {
        self.microBean?.handle(interactionMessage: .presentCameraViewController(imageView: self.imageView,
                                                                                vc: self))
    }

    @IBAction private func touchCompleteDelivery() {
        if self.imageView.image == nil {
            print("No image")
        } else {
            print("Complete Delivery")
            self.microBean?.handle(inputMessage: .completeOrder)
        }
    }
}

extension OrderCompletionViewController: ViewControllerConfigurable {

    typealias VM = OrderCompletionViewModel

    typealias I = OrderCompletionInputMessage
    enum OrderCompletionInputMessage: InputMessage {
        case completeOrder
    }

    typealias O = OrderCompletionOutputMessage
    enum OrderCompletionOutputMessage: OutputMessage {
        case completeOrder
    }
}

extension OrderCompletionViewController: ViewContollerInteractable {

    typealias VI = OrderCompletionViewInteractor

    typealias IM = OrderCompletionInteractionMessage
    enum OrderCompletionInteractionMessage: InteractionMessage {
        case presentCameraViewController(imageView: UIImageView,
                                         vc: UIViewController)
        case dismissCompletionViewController(vc: UIViewController)
    }

    func convertToInteraction(from outputMessage: O) -> IM {
        switch outputMessage {
        case .completeOrder:
            return .dismissCompletionViewController(vc: self)
        }
    }
}

