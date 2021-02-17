//
//  AuthenticationViewModel.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit

protocol formViewModel {
    
    func updateForm()
}

// the point of this protocol is to make sure, whatever structure adopts it, they have to conform to the properites inside.
protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor {get}
    var buttonTitleColor: UIColor {get}
    
}


struct LoginViewModel: AuthenticationViewModel {
    
    var email: String?
    var password: String?
    
    // if both properties above is not empty, that means formIsValid is equal to true.
    var formIsValid: Bool {
    
        return email?.isEmpty == false && password?.isEmpty == false
        
    }
    
    // if form is valid is true, the first value after the question mark is always the success case, if its false then the second value will happen
    var buttonBackgroundColor: UIColor {
        
        return formIsValid ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 0.6148123741, green: 0.1017967239, blue: 0.1002308354, alpha: 1).withAlphaComponent(0.5)
        
    }
    
    var buttonTitleColor: UIColor {
        
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
        
    }
    
    
    
}


struct RegistrationViewModel: AuthenticationViewModel {
    var name: String?
    var userName: String?
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        
        return email?.isEmpty == false && password?.isEmpty == false && userName?.isEmpty == false && name?.isEmpty == false

    }
    
    var buttonBackgroundColor: UIColor {
        
        return formIsValid ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 0.6148123741, green: 0.1017967239, blue: 0.1002308354, alpha: 1).withAlphaComponent(0.5)

    }
    
    var buttonTitleColor: UIColor {
        
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)

    }
    
    
    
    
}
