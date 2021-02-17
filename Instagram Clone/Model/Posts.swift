//
//  Posts.swift
//  Instagram Clone
//
//  Created by benny mushiya on 16/02/2021.
//

import UIKit
import Firebase


struct Posts {
    
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timeStamp: Timestamp
    let postId: String
    let ownerImageUrl: String
    let ownerUserName: String
    
    
    init(postId: String ,dictionary: [String : Any]) {
        
        // the string at the end is a defualt value incase nothing is there then we pass the nill value
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = postId
        self.ownerImageUrl = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUserName = dictionary["ownerUserName"] as? String ?? ""
        
        
        
        
    }
}
