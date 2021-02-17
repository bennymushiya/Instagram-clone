//
//  UploadPostController.swift
//  Instagram Clone
//
//  Created by benny mushiya on 15/02/2021.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: User?
    
    // as soon as the view is loaded, we set selected image to photoImageView, on the UI
    var selectedImage: UIImage? {
        didSet{photoImageView.image = selectedImage }
        
    }
    
    private let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "enter caption"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.delegate = self
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        
        return label
    }()
    
    
    //MARK: - LIFECYCLE

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
    }
    
    
    //MARK: - HELPERS

    func configureUI() {
        
        view.backgroundColor = .white
        
        navigationItem.title = "upload post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDidTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleDone))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom: -8, paddingRight: 12)
        
        
    }
    
    
    //MARK: - ACTION
    
    /// if the text/charcter reaches a certain amount of number, then the user wont be able to continue writing
    func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        
        if (textView.text.count) > maxLength {
            
            textView.deleteBackward()
        }
    }

    @objc func handleDidTapCancel() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleDone() {
        
        // we unwrap it because its optional
        guard let selectedImage = selectedImage else {return}
        guard let caption = captionTextView.text else {return}
        guard let user = currentUser else {return}
        
        showLoader(true)
        
        // always make sure to return out of your errors, to stop it from keep executing to mess with your data upload and other functionalities.
        PostsService.uploadPost(caption: caption, image: selectedImage, user: user) { error in
            
            // once the proccess completes, regardless of error or not we will hide the loader.
            self.showLoader(false)
            
            if let error = error {
                
                print("failed to upload posts because of \(error.localizedDescription)")
                return
            }
            
            print("successfully uploaded posts")
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
        
    }
    
    
}

//MARK: - UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
    
    /// if textView did change then call the function check maxLength, which makes sure the text does not exceed 100
    func textViewDidChange(_ textView: UITextView) {
        
        checkMaxLength(textView, maxLength: 100)
        
        // gets the text view count
        let count = textView.text.count
        
        // assgins the count of the textView to this label.
        characterCountLabel.text = "\(count)/100"
    }
    
}





