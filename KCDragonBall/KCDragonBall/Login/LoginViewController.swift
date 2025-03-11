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
    
    private var networkModel: NetworkModelProtocol
    
    // MARK: Lifecycle
    init(networkModel: NetworkModelProtocol) {
        self.networkModel = networkModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Oulet Actions
    @IBAction func login(_ sender: UIButton) {
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            // TODO: Add Regex linter
            Logger.debug.error("Empty user")
            return
        }
        
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty  else {
            // TODO: Add Regex linter
            Logger.debug.error("Empty password")
            return
        }
        
        networkModel.jwt(user: emailText, password: passwordText) { result in
            switch result {
            case .success:
                // TODO: Continue with the next screen
                Logger.debug.log("Logged!")
            case .failure(let error):
                // TODO: Handle errors
                Logger.debug.error("\(error)")
            }
        }
    }
}
