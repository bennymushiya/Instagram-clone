//
//  AuthButton.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit



class AuthButton: UIButton {
    
    
    init(title: String, type: ButtonType) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 5
        backgroundColor = .red
        setHeight(50)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
