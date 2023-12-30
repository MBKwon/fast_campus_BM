//
//  SSOViewController.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/12/30.
//

import UIKit

class SSOViewController: UIViewController {

    @IBOutlet private weak var userNameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var ssoButton: UIButton!

    var afterLoginBlock: (() -> Void)?

    private let ssoAppScheme = "ssoauth://"
    private var isInstalledAuth: Bool {
        guard let appscheme = URL(string: self.ssoAppScheme) else { return false }
        return UIApplication.shared.canOpenURL(appscheme)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkAuthSession()
    }
}

extension SSOViewController {
    private func checkAuthSession() {
        Task { @MainActor in

            let result = await SSOController.shared.checktUserInfo()
            print(result)

            switch result {
                case .success:
                    self.afterLoginBlock?()
                case .failure:
                    self.showLoginComponents()
            }
        }
    }

    private func getAuth() {
        Task { @MainActor in

            guard let userName = self.userNameField.text,
                  let password = self.passwordField.text else {
                return
            }

            let result = await SSOController.shared.readUserInfo(id: userName, password: password)
            print(result)

            switch result {
                case .success:
                    self.afterLoginBlock?()
                case .failure:
                    self.showLoginComponents()
            }
        }
    }
}

extension SSOViewController {

    private func callAuthApp() {
        guard let appscheme = URL(string: self.ssoAppScheme) else { return }
        UIApplication.shared.open(appscheme)
    }

    private func showLoginComponents() {
        self.ssoButton.alpha = 1.0

        if self.isInstalledAuth {
            self.userNameField.alpha = 0.0
            self.passwordField.alpha = 0.0
        } else {
            self.userNameField.alpha = 1.0
            self.passwordField.alpha = 1.0
        }
    }

    @IBAction private func touchSSOButton() {
        if self.isInstalledAuth {
            self.callAuthApp()
        } else {
            self.getAuth()
        }
    }

    @IBAction private func dismissKeyboard() {
        self.userNameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
    }
}
