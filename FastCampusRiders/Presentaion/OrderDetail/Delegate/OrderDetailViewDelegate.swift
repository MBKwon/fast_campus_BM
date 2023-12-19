//
//  OrderDetailViewDelegate.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/12.
//

import CoreLocation
import UIKit

class OrderDetailViewDelegate: NSObject {

    private let viewController: OrderDetailViewController
    private let OrderDetailInfo: OrderDetailInfo
    private var detailInfoList: [OrderDetailCellType]

    private enum OrderDetailCellType {
        case map(detailInfo: OrderDetailInfo, routes: [CLLocation]?)
        case description(detailInfo: OrderDetailInfo)
        case foldableCell(title: String,
                          cellInfo: OrderDetailCellFoldableType,
                          isFolded: Bool,
                          textColor: UIColor)

        var cellHeight: CGFloat {
            switch self {
                case .map:
                    return 289.0

                case .description:
                    return 430.0

                case .foldableCell:
                    return 52.0
            }
        }
    }

    private enum OrderDetailCellFoldableType {
        case memo(memo: String)
        case storeInfo(locationInfo: LocationDetailInfo, tintColor: UIColor)
        case destinationInfo(locationInfo: LocationDetailInfo, tintColor: UIColor)
        case receiptInfo(detailInfo: OrderDetailInfo)

        var cellHeight: CGFloat {
            switch self {
                case .memo, .receiptInfo:
                    return UITableView.automaticDimension
                case .storeInfo, .destinationInfo:
                    return 143.0
            }
        }
    }

    init(detailInfo: OrderDetailInfo,
         on viewController: OrderDetailViewController) {
        self.viewController = viewController
        self.OrderDetailInfo = detailInfo
        self.detailInfoList = OrderDetailViewDelegate.setupTableViewData(detailInfo: detailInfo, 
                                                                         routes: nil)
    }
}

extension OrderDetailViewDelegate {
    func drawRoutes(_ routes: [CLLocation]?) {
        self.detailInfoList = OrderDetailViewDelegate.setupTableViewData(detailInfo: self.OrderDetailInfo,
                                                                         routes: routes)
    }

    private static func setupTableViewData(detailInfo: OrderDetailInfo,
                                           routes: [CLLocation]?) -> [OrderDetailCellType] {
        var detailInfoType: [OrderDetailCellType] = [
            .map(detailInfo: detailInfo, routes: routes),
            .description(detailInfo: detailInfo)
        ]

        if let memo = detailInfo.memo {
            detailInfoType.append(contentsOf: [
                .foldableCell(title: "요청사항",
                              cellInfo: .memo(memo: memo),
                              isFolded: false,
                              textColor: UIColor(white: 0.188, alpha: 1.0))

            ])
        }

        let storeTintColor = UIColor(red: 0.153, green: 0.667, blue: 0.882, alpha: 1)
        let destinationTintColor = UIColor(red: 1, green: 0.72, blue: 0, alpha: 1)
        detailInfoType.append(contentsOf: [
            .foldableCell(title: "픽업지 정보",
                          cellInfo: .storeInfo(locationInfo: detailInfo.storeInfo, tintColor: storeTintColor),
                          isFolded: false,
                          textColor: storeTintColor),
            .foldableCell(title: "전달지 정보",
                          cellInfo: .destinationInfo(locationInfo: detailInfo.destinationInfo, tintColor: destinationTintColor),
                          isFolded: false,
                          textColor: destinationTintColor),
            .foldableCell(title: "주문 정보",
                          cellInfo: .receiptInfo(detailInfo: detailInfo),
                          isFolded: false,
                          textColor: UIColor(white: 0.188, alpha: 1.0))
        ])

        return detailInfoType
    }
}

extension OrderDetailViewDelegate: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.detailInfoList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellType = self.detailInfoList[section]
        switch cellType {
            case .map, .description:
                return 1
            case .foldableCell(_, _, let isFolded, _):
                if isFolded {
                    return 1
                } else {
                    return 2
                }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.detailInfoList[indexPath.section]
        switch cellType {
            case .map(let detailInfo, let routes):
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailMapViewCell.cellIdentifier,
                                                         for: indexPath)

                if let cell = cell as? OrderDetailMapViewCell {
                    if let routes = routes {
                        cell.drawRoute(routeData: routes)
                    }
                    cell.bindNavigationAction(self.presentDirectionActionSheet(with: detailInfo))
                    cell.bindRouteAction {
                        let trackOrderSegue = OrderDetailViewController.SegueIdentifier.trackOrder
                        self.viewController.performSegue(withIdentifier: trackOrderSegue,
                                                         sender: detailInfo)
                    }
                }
                return cell

            case .description(let detailInfo):
                let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailDescriptionCell.cellIdentifier,
                                                         for: indexPath)

                if let cell = cell as? OrderDetailDescriptionCell {
                    cell.updateUI(with: detailInfo)
                    cell.bindActionButton { dealInfo in
                        switch dealInfo.status {
                            case .pending:
                                print("배달로 변경")
                            case .delivering:
                                let completionSegue = OrderDetailViewController.SegueIdentifier.completeDelivery
                                self.viewController.performSegue(withIdentifier: completionSegue,
                                                                 sender: dealInfo.id)
                            case .completed:
                                print("이미 완료")
                        }
                    }
                }
                return cell

            case .foldableCell(let title, let cellInfo, let isFolded, let textColor):
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailTitleCell.cellIdentifier,
                                                             for: indexPath)

                    if let cell = cell as? OrderDetailTitleCell {
                        cell.updateUI(with: title, isFolded: isFolded, color: textColor)
                    }
                    return cell
                } else {
                    switch cellInfo {
                        case .memo(let memo):
                            let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailMemoCell.cellIdentifier,
                                                                     for: indexPath)

                            if let cell = cell as? OrderDetailMemoCell {
                                cell.updateUI(with: memo)
                            }
                            return cell
                        case .storeInfo(let locationInfo, let tintColor),
                                .destinationInfo(let locationInfo, let tintColor):
                            let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailContactCell.cellIdentifier,
                                                                     for: indexPath)

                            if let cell = cell as? OrderDetailContactCell {
                                cell.updateUI(with: locationInfo, color: tintColor)
                            }
                            return cell
                        case .receiptInfo(let detailInfo):
                            let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailReceiptCell.cellIdentifier,
                                                                     for: indexPath)

                            if let cell = cell as? OrderDetailReceiptCell {
                                cell.updateUI(with: detailInfo)
                            }
                            return cell
                    }
                }
        }
    }
}

extension OrderDetailViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = self.detailInfoList[indexPath.section]
        switch cellType {
            case .map, .description:
                return cellType.cellHeight

            case .foldableCell(_, let cellInfo, _, _):
                if indexPath.row == 0 {
                    return cellType.cellHeight
                } else {
                    return cellInfo.cellHeight
                }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = self.detailInfoList[indexPath.section]
        switch cellType {
            case .map, .description:
                do { }

            case .foldableCell(let title, let cellInfo, let isFolded, let textColor):
                if indexPath.row == 0 {
                    self.detailInfoList[indexPath.section] = .foldableCell(title: title,
                                                                           cellInfo: cellInfo,
                                                                           isFolded: !isFolded,
                                                                           textColor: textColor)
                    tableView.reloadSections([indexPath.section], with: .automatic)
                } else {
                    do { }
                }
        }
    }
}

extension OrderDetailViewDelegate {
    private func presentDirectionActionSheet(with dealInfo: OrderDetailInfo) -> () -> Void {
        return {
            let mapAppsList = MapManager.getMapApps()
            if mapAppsList.count == 0 {
                let actionSheet = UIAlertController(title: "Direction",
                                                    message: "No app you can use",
                                                    preferredStyle: .actionSheet)

                actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { _ in
                    actionSheet.dismiss(animated: true)
                }))

                self.viewController.present(actionSheet, animated: true)
            } else {
                let actionSheet = UIAlertController(title: "Direction",
                                                    message: "choose a map you'd like to use",
                                                    preferredStyle: .actionSheet)

                mapAppsList.compactMap { mapItem in
                    UIAlertAction(title: mapItem.appName, style: .default) { _ in
                        switch dealInfo.status {
                            case .pending:
                                mapItem.openAppToGetDirections(with: dealInfo.storeInfo.locationCoordinate,
                                                               name: dealInfo.storeInfo.locationName)
                            case .delivering:
                                mapItem.openAppToGetDirections(with: dealInfo.destinationInfo.locationCoordinate,
                                                               name: dealInfo.destinationInfo.locationName)
                            case .completed:
                                assertionFailure("The order is completed")
                        }
                    }
                }.forEach(actionSheet.addAction(_:))

                actionSheet.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { _ in
                    actionSheet.dismiss(animated: true)
                }))

                self.viewController.present(actionSheet, animated: true)
            }
        }
    }
}
