//
//  User.swift
//  Instagram Clone
//
//  Created by benny mushiya on 13/02/2021.
//

import UIKit
import Firebase

struct User {
    
    let name: String
    let userName: String
    let email: String
    let profileImage: String
    let uid: String
    
    var isFollowed = false
    
    var stats: UserStats!
    
    // it will only return true if the current uid is equal to the uid above
    var isCurrentUser: Bool {
        
        return Auth.auth().currentUser?.uid == uid
        
    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        // we give stats an initialise value, so it doesnt crash, whilst we wait for the API call to complete 
        self.stats = UserStats(followers: 0, following: 0)
    }
    
}


struct UserStats {
    
    let followers: Int
    let following: Int
    
}
