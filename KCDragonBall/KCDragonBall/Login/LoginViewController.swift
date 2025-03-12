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
        // TODO: Continue with the next screen
        Logger.debug.log("Logged in!")
        
        DispatchQueue.main.async {
            self.configureTabBarController()
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
        }
    }
}

extension LoginViewController {
    private func configureTabBarController() {
        let tabBarController = UITabBarController()
        
        let herosCollectionViewController = UIViewController()
        let herosNavigationController = UINavigationController(rootViewController: herosCollectionViewController)
        herosNavigationController.tabBarItem = UITabBarItem(
            title: "Heros",
            image: UIImage(systemName: "gamecontroller"),
            selectedImage: UIImage(systemName: "gamecontroller.fill"))
        let favoritesTableViewControler = UIViewController()
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesTableViewControler)
        favoritesNavigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart.circle"),
            selectedImage: UIImage(systemName: "heart.circle.fill"))
        
        tabBarController.viewControllers = [herosNavigationController, favoritesNavigationController]
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            Logger.debug.error("SceneDelegate is not properly configured")
            return
        }
        sceneDelegate.window?.rootViewController = tabBarController
    }
}
