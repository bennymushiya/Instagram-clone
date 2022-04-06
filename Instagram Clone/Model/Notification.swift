//
//  Notification.swift
//  Instagram Clone
//
//  Created by benny mushiya on 18/02/2021.
//

import UIKit
import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    // we use an enum to distinguish between our notification types. based on the notification they send the other user will recieve the message below.
    var notificationMessage: String {
        
        switch self {
        case .like:
            return "liked your  posts"
        case .follow:
            return "started following you"
        case .comment:
            return "commented on your post"
        }
    }
    
}


struct Notification {
    
    let uid: String
    var postImageUrl: String?
    var postId: String?
    let timeStamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageUrl: String
    let userName: String
    
    var userIsFollowed = false
    
    
    init(dictionary: [String: Any]) {
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.id = dictionary["id"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.postImageUrl = dictionary["postImageUrl"] as? String ?? ""
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.userProfileImageUrl = dictionary["userProfileImageUrl"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""





        
        
    }
    
    
}
