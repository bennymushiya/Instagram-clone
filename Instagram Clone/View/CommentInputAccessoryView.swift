//
//  CommentInputAccessoryView.swift
//  Instagram Clone
//
//  Created by benny mushiya on 17/02/2021.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: class {
    
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String)
}

class CommentInputAccessoryView: UIView {
    
    
    //MARK: - PROPERTIES
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeHolderText = "enter text here"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.isScrollEnabled = false
        tv.placeHolderShouldCenter = true
        return tv
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTap), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - LIFECYCLE

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // figures out the size based on the dimensions of the viewController, inside the View.
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    //MARK: - HELPERS

    func configureUI() {
        
        // adjusts the view to fit into any screen size.
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)

        let divider = UIView()
        divider.backgroundColor = .black
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
    }
    
    //MARK: - ACTION

    @objc func handlePostTap() {
        
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
        
    }
    
    /// if comment text is equal to nill, then we show the placeholderLabel. but if its not nil then we hide the placeholder text.
    func clearCommentTextView() {
        
        commentTextView.text = nil
        commentTextView.placeHolderLabel.isHidden = false
        
    }
    
    
}
