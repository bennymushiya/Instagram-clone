//
//  NotificationViewModel.swift
//  Instagram Clone
//
//  Created by benny mushiya on 20/02/2021.
//

import UIKit

struct NotificationViewModel {
    
    var notification: Notification
    
    
    var postImageUrl: URL? {
        
        return URL(string: notification.postImageUrl ?? "")
    }
    
    
    var profileImageURL: URL? {
        
        return URL(string: notification.userProfileImageUrl)
    }
    
    
    // we use this to return both message and username, with different fonts and sizes
    var notificationMessage: NSAttributedString {
        
        let userName = notification.userName
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: userName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "  2m", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    
    // if the notification type is same as follow, then we hide the postImage.
    var shouldHidePostImage: Bool {
        
        return notification.type == .follow
    }
    
    var followButtonText: String {
        
        return notification.userIsFollowed ? "following" : "follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        
        return notification.userIsFollowed ? .white : .blue
        
    }
    
    
    var followButtonTextColor: UIColor {
        
        return notification.userIsFollowed ? .black : .white
        
    }
    
    
    init(notification: Notification) {
        self.notification = notification
        
    }
    
}
