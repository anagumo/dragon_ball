//
//  SignInViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 11/03/25.
//

import UIKit
import OSLog

class LoginViewController: UIViewController {
    // MARK: UI Components
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userErrorLabel: UILabel!
    @IBOutlet var passwordErrorLabel: UILabel!
    
    private var networkModel: NetworkModelProtocol
    
    // MARK: Lifecycle
    init(networkModel: NetworkModelProtocol) {
        self.networkModel = networkModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Oulet Actions
    @IBAction func login(_ sender: UIButton) {
        userErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        networkModel.jwt(user: emailTextField.text ?? "", password: passwordTextField.text ?? "") { [weak self] result in
            switch result {
            case .success:
                Logger.debug.log("Logged in!")
                // TODO: Continue with the next screen
            case let .failure(error):
                switch error {
                case .emailFormat:
                    DispatchQueue.main.async {
                        self?.userErrorLabel.text = error.message
                        self?.userErrorLabel.isHidden = false
                    }
                case .passwordFormat:
                    DispatchQueue.main.async {
                        self?.passwordErrorLabel.text = error.message
                        self?.passwordErrorLabel.isHidden = false
                    }
                default:
                    Logger.debug.error("\(error.message)")
                }
            }
        }
    }
}
