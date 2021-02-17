//
//  UserCellViewModel.swift
//  Instagram Clone
//
//  Created by benny mushiya on 14/02/2021.
//

import UIKit


struct UserCellViewModel {
    
    var user: User
    
    
    var fullName: String {
        
        return user.name
    }
    
    var userName: String {
        
        return user.userName
    }
    
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
    }
    
    
    init(user: User) {
        self.user = user
        
    }
    
}
