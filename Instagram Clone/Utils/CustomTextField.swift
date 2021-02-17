//
//  CustomTextField.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//


import UIKit

class CustomTextField: UITextField {
    
    
    init(placeholders: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 12, width: 40)
        leftView = spacer
        leftViewMode = .always
        
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(50)
        attributedPlaceholder = NSAttributedString(string: placeholders, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        
                  
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
