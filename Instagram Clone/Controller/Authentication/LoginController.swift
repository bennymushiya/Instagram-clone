//
//  LoginController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit

protocol AuthenicationCompleteDelegate: class {
    
    func AuthenicationDidComplete()
}

class LoginController: UIViewController {
    
    //MARK: - PROPERTIES
    
    weak var delegate: AuthenicationCompleteDelegate?
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
          let logo = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
          return logo
      }()
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholders: "email")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        return tf
    }()
    
    private let PasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholders: "Password")
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

        return tf
    }()
    
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .red
        button.setHeight(50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
      
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: " forgot your password", secondPart: " get help siging in")
    
        return button
       }()
    
    private let dontHaveAnAccount: UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Dont have an account? go back to", secondPart: "Main Screen")
        button.addTarget(self, action: #selector(handleSignUpController), for: .touchUpInside)
        
        return button
       }()
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, PasswordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(dontHaveAnAccount)
        dontHaveAnAccount.centerX(inView: view)
        dontHaveAnAccount.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    
    
    //MARK: - ACTION
    
    @objc func handleSignUpController() {
        
        let controller = RegistrationController()
        // we assign our delegate to the controllers delegate, giving it access to our properties
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    /// if the sender which is a UITextField  is the same as emailTextField, then we assign the senders text to the email string property inside our viewModel making it not empty, thus formIsValid becomes true.
    @objc func textDidChange(sender: UITextField) {
        
        if sender == emailTextField {
           
            viewModel.email = sender.text
           
        }else {
            
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text else {return}
        guard let password = PasswordTextField.text else {return}
        
        AuthService.logUserIn(withEmail: email, password: password) { (results, error) in
            if let error = error {
                print("failed to log user in \(error.localizedDescription)")
                return
            }
            
            // refetches a new user when new user loggs in
            self.delegate?.AuthenicationDidComplete()
            print("successfully logged user in")
        }
        
        
    }
    
}

//MARK: - formViewModel


extension LoginController: formViewModel {
    func updateForm() {
        
        // if form is valid or not valid, the button background will change color based on that, becasue we called this method in our viewModel.
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
        
    }

    
    
}



