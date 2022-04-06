//
//  RegistrationController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit
import Firebase


class RegistrationController: UIViewController {
    
    //MARK: - PROPERTIES
    
    weak var delegate: AuthenicationCompleteDelegate?
    private var viewModel = RegistrationViewModel()
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let ProfileImage: UIButton = {
        let profile = UIButton(type: .system)
        profile.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        profile.clipsToBounds = true
        profile.layer.cornerRadius = 10
        profile.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        profile.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        
        return profile
    }()
    
    private let nameTextField = CustomTextField(placeholders: "name")
    private let userNameTextField = CustomTextField(placeholders: "username")
    
    private let emailTextField: CustomTextField = {
        let tf = CustomTextField(placeholders: "email")
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    private let PasswordTextField: CustomTextField = {
        let tf = CustomTextField(placeholders: "Password")
        tf.isSecureTextEntry = true

        return tf
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .red
        button.setHeight(50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
      
        return button
    }()
    
    private let dontHaveAnAccount: UIButton = {
        let button = UIButton()
        button.attributedTitle(firstPart: "Dont have an account? go back to", secondPart: "Main Screen")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
       }()
   
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureGradientLayer()
        configureUI()
        configureNotificationObservers()
    }
    
    
    
    //MARK: - HELPERS
    
    func configureUI() {
        
        imagePicker.delegate = self
        
        view.addSubview(ProfileImage)
        ProfileImage.centerX(inView: view)
        ProfileImage.setDimensions(height: 140, width: 140)
        ProfileImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [userNameTextField, nameTextField, emailTextField, PasswordTextField, signInButton ])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: ProfileImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAnAccount)
        dontHaveAnAccount.centerX(inView: view)
        dontHaveAnAccount.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        
    }
    
    func configureNotificationObservers() {
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        PasswordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
    }
    
    
    
    //MARK: - ACTION
    
    @objc func handleSelectPhoto() {
        
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @objc func textDidChange(sender: UITextField) {
        
        if sender == emailTextField {
        
            viewModel.email = sender.text
            
        }else if sender == PasswordTextField {
            
            viewModel.password = sender.text
            
        }else if sender == userNameTextField {
            
            viewModel.userName = sender.text
        }else {
            
            viewModel.name = sender.text
        }
        
        updateForm()
        
    }
    
    /// removes the top viewController in top of the nav, showing the old viewController, because when push nav is called it adds a viewController on top of the other one.
    @objc func handleShowLogin() {
        
        navigationController?.popViewController(animated: true)
        
    }
    


 @objc func handleRegistration() {
    guard let userName = userNameTextField.text else {return}
    guard let Name = nameTextField.text else {return}
    guard let email = emailTextField.text else {return}
    guard let password = PasswordTextField.text else {return}
    guard let profileImage = profileImage else {return}
    
    let credentials = AuthCredentials.init(name: Name, username: userName, email: email, password: password, profileImage: profileImage)
    
    AuthService.registerUser(withCredentials: credentials) { error in
        if let error = error {
            print("failed to upload data \(error.localizedDescription)")
            return
        }
        
        self.delegate?.AuthenicationDidComplete()
        print("successfully uploaded user data ")
    }
    
}
    
}

//MARK: - formViewModel

extension RegistrationController: formViewModel {
    func updateForm() {
        signInButton.backgroundColor = viewModel.buttonBackgroundColor
        signInButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signInButton.isEnabled = viewModel.formIsValid
        
    }
    
}


extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // the info is like a dictionary, that we downcast into a uiimage.
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        
        profileImage = selectedImage
        
        ProfileImage.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
    
    
    
    



