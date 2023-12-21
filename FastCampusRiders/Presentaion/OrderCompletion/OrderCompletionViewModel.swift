//
//  OrderCompletionViewModel.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/21.
//

import Combine
import Foundation
import MBAkit

class OrderCompletionViewModel: ViewModelConfigurable {
    typealias VC = OrderCompletionViewController

    var outputSubject = PassthroughSubject<Result<VC.O, Error>, Never>()

    func handleMessage(_ inputMessage: VC.I) {
        switch inputMessage {
            case .completeOrder:
                self.outputSubject.send(.success(.completeOrder))
        }
    }
}
