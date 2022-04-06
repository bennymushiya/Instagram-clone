//
//  Comment.swift
//  Instagram Clone
//
//  Created by benny mushiya on 17/02/2021.
//

import Firebase


struct Comments {
    
    let uid: String
    let userName: String
    let profileImageUrl: String
    let commentText: String
    let timeStamp: Timestamp
    
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.commentText = dictionary["comment"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        
    }
    
    
}
