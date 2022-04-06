//
//  ProfileViewModel.swift
//  Instagram Clone
//
//  Created by benny mushiya on 13/02/2021.
//

import UIKit


struct ProfileHeaderViewModel {
    
    var user: User
    
    
    var userName: String {
        
        return user.userName
        
    }
    
    var name: String {
        
        return user.name
    }
    
    var profileImage: URL? {
        
        return URL(string: user.profileImage)
    }
    
    // if the user is the signed in user, then return edit profile, else if isFollowed is true then return following, if false return follow
    var followButtonText: String {
        
        if user.isCurrentUser {
            
            return "Edit Profile"
        }
        
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        
        return user.isCurrentUser ? .white : .systemPink
        
    }
    
    var followButtonTextColor: UIColor {
        
        return user.isCurrentUser ? .black : .white
        
    }
    
    var numberOfFollowers: NSAttributedString {
        
        return attributedStatText(value: user.stats.followers, label: "Followers")
    }
    
    var numberOfFollowing: NSAttributedString {
        
        return attributedStatText(value: user.stats.following, label: "Following")
    }
    
    var numberOfPosts: NSAttributedString {
        
        return attributedStatText(value: user.stats.posts, label: "Posts")
    }
    
    
    init(user: User) {
        self.user = user
        
    }
    
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
}
