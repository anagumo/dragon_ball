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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Oulet Actions
    @IBAction func login(_ sender: UIButton) {
        sender.configuration?.showsActivityIndicator = true
        
        userErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        networkModel.jwt(
            user: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) { [weak self] result in
            DispatchQueue.main.async {
                sender.configuration?.showsActivityIndicator = false
            }
            
            switch result {
            case .success:
                self?.onLoginSuccess()
            case let .failure(apiClientError):
                self?.onLoginError(apiClientError)
            }
        }
    }
    
    private func onLoginSuccess() {
        Logger.debug.log("Logged in!")
        
        DispatchQueue.main.async {
            self.configureMainController()
        }
    }
    
    private func onLoginError(_ apiClientError: APIClientError) {
        switch apiClientError {
        case .emailFormat:
            DispatchQueue.main.async {
                self.userErrorLabel.text = apiClientError.message
                self.userErrorLabel.isHidden = false
            }
        case .passwordFormat:
            DispatchQueue.main.async {
                self.passwordErrorLabel.text = apiClientError.message
                self.passwordErrorLabel.isHidden = false
            }
        default:
            Logger.debug.error("\(apiClientError.message)")
            DispatchQueue.main.async {
                let uiAlertController = UIAlertController(
                    title: "Error",
                    message: apiClientError.message,
                    preferredStyle: .alert)
                
                uiAlertController.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default
                    )
                )
                
                self.present(uiAlertController, animated: true)
            }
        }
    }
}

extension LoginViewController {
    private func configureMainController() {
        let herosCollectionViewController = HerosCollectionViewController(networwModel: networkModel)
        let herosNavigationController = UINavigationController(rootViewController: herosCollectionViewController)
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            Logger.debug.error("SceneDelegate is not properly configured")
            return
        }
        sceneDelegate.window?.rootViewController = herosNavigationController
    }
}
