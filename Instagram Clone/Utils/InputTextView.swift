//
//  InputTextView.swift
//  Instagram Clone
//
//  Created by benny mushiya on 16/02/2021.
//

import UIKit

// to enable a placeholder inside a textview
class InputTextView: UITextView {
    
    
    //MARK: - PROPERTIES
    
    // when the view is loaded we will set the placeholderText to placeholder label.
    var placeHolderText: String? {
        
        didSet{ placeHolderLabel.text = placeHolderText}
        
    }
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    /// if placeHolderShouldCenter equals true, then the placeHolder label should be centered in the middle of the View, else should be centered at the top.
    var placeHolderShouldCenter = true {
        didSet {
            
            if placeHolderShouldCenter {
                placeHolderLabel.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 8)
                placeHolderLabel.centerX(inView: self)
            }else {
                
                placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8)
                
            }
        }
        
    }
    
    //MARK: - LIFECYCLE

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 8)
        
        // this is the same as addTarget, but we are using notifcation center instead.
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - ACTION

    @objc func handleTextDidChange() {
        
        // if the text is empty make isHidden true, if the text is not empty make isHidden fasle.
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
