//
//  SSOController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/25.
//

import Foundation
import KeychainAccess

class SSOController {
    static let shared = SSOController()

    enum SSOStatus {
        case startAuth(id: String, password: String)
        case requestToken(id: String, password: String)
        case refreshAccessToken(refreshToken: String)
        case requestUserInfo(accessToken: String)
        case userInfo(userInfo: SSOUserInfo)
    }

    enum SSOError: Error {
        case noAppID
        case noAppSecret
        case needRefresh
        case invalidToken
        case invalidAccount
        case invalidPasswd
        case expiredToken
    }

    private var appID: String? = nil
    private var appSecret: String? = nil
    private let keychain: Keychain

    enum SSOKeychainKey: String {
        case accessToken
        case refreshToken
        case userInfo
    }

    private init() {
        self.keychain = Keychain(service: "com.example.SSOController")

        let mainBudle = Bundle.main
        guard let appID = mainBudle.object(forInfoDictionaryKey: "appID") as? String else {
            assertionFailure("noAppID")
            return
        }
        self.appID = appID

        guard let appSecret = mainBudle.object(forInfoDictionaryKey: "appID") as? String else {
            assertionFailure("noAppSecret")
            return
        }
        self.appSecret = appSecret
    }
}

// public methods
extension SSOController {
    func checkAndGetUserInfo(id: String, password: String) async -> Result<SSOStatus, Error> {
        await Result.success(SSOStatus.startAuth(id: id, password: password))
            .flatMap(self.validateToken(_:))
            .flatMapAsync(self.requestToken(_:))
            .flatMapAsync(self.refreshToken(_:))
            .flatMapAsync(self.requestUserInfo(_:))
    }

}

// private methods
extension SSOController {

    private func validateToken(_ status: SSOStatus) -> Result<SSOStatus, Error> {
        guard case .startAuth(let id, let password) = status else {
            return .success(status)
        }

        guard let accessToken = self.keychain[SSOKeychainKey.accessToken.rawValue] else {
            return .failure(SSOError.expiredToken)
        }

        // Call token validation API
        let isValid = arc4random() % 2 == 1 ? true : false
        if isValid {
            return .success(.requestUserInfo(accessToken: accessToken))
        } else if let refreshToken = self.keychain[SSOKeychainKey.refreshToken.rawValue] {
            return .success(.refreshAccessToken(refreshToken: refreshToken))
        } else {
            return .success(.requestToken(id: id, password: password))
        }
    }

    private func requestToken(_ status: SSOStatus) async -> Result<SSOStatus, Error> {
        guard case .requestToken(let id, let password) = status else {
            return .success(status)
        }

        guard let appID = self.appID else {
            return .failure(SSOError.noAppID)
        }

        guard let appSecret = self.appSecret else {
            return .failure(SSOError.noAppSecret)
        }

        let apiPath = APIController.Path.issueToken(appID: appID,
                                                    secret: appSecret,
                                                    id: id, password: password)

        let result = await APIController.shared
            .request(path: apiPath, method: .get)
            .decode(decoder: IssueTokenInfo.self)

        return await withCheckedContinuation({ continuation in
            result.fold { tokenInfo in
                continuation.resume(returning: .success(.requestUserInfo(accessToken: tokenInfo.accessToken)))
            } failure: { error in
                continuation.resume(returning: .failure(error))
            }
        })
    }

    private func refreshToken(_ status: SSOStatus) async -> Result<SSOStatus, Error> {
        guard case .refreshAccessToken(let refreshToken) = status else {
            return .success(status)
        }

        guard let appID = self.appID else {
            return .failure(SSOError.noAppID)
        }

        guard let appSecret = self.appSecret else {
            return .failure(SSOError.noAppSecret)
        }

        let apiPath = APIController.Path.refreshToken(appID: appID, secret: appSecret,
                                                      refreshToken: refreshToken)

        let result = await APIController.shared
            .request(path: apiPath, method: .get)
            .decode(decoder: RefreshTokenInfo.self)

        return await withCheckedContinuation({ continuation in
            result.fold { tokenInfo in
                continuation.resume(returning: .success(.requestUserInfo(accessToken: tokenInfo.accessToken)))
            } failure: { error in
                continuation.resume(returning: .failure(error))
            }
        })
    }

    private func requestUserInfo(_ status: SSOStatus) async -> Result<SSOStatus, Error> {
        guard case .requestUserInfo(let accessToken) = status else {
            return .success(status)
        }

        guard let appID = self.appID else {
            return .failure(SSOError.noAppID)
        }

        guard let appSecret = self.appSecret else {
            return .failure(SSOError.noAppSecret)
        }

        let apiPath = APIController.Path.readUserInfo(appID: appID, secret: appSecret, accessToken: accessToken)

        let result = await APIController.shared
            .request(path: apiPath, method: .get)
            .decode(decoder: SSOUserInfo.self)

        return await withCheckedContinuation({ continuation in
            result.fold { userInfo in
                continuation.resume(returning: .success(.userInfo(userInfo: userInfo)))
            } failure: { error in
                continuation.resume(returning: .failure(error))
            }
        })
    }
}

extension Result where Success == SSOController.SSOStatus {
    func flatMap(_ transform: (Success) -> Self) -> Self {
        switch self {
            case .success(let status):
                return transform(status)
            case .failure:
                return self
        }
    }

    func flatMapAsync(_ transform: (Success) async -> Self) async -> Self {
        switch self {
            case .success(let status):
                return await transform(status)
            case .failure:
                return self
        }
    }
}
