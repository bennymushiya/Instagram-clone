//
//  PostViewModel.swift
//  Instagram Clone
//
//  Created by benny mushiya on 16/02/2021.
//

import UIKit


struct PostViewModel {
    
    var posts: Posts
    
    var imageUrl: URL? {
        
        return URL(string: posts.imageUrl)
    }
    
    var profileImage: URL? {
        
        return URL(string: posts.ownerImageUrl)
    }
    
    var userName: String {
        
        return posts.ownerUserName
    }
    
    var ownerUid: String {
        
        return posts.ownerUid
    }
    
    var caption: String {
        
        return posts.caption
        
    }
    
    var likes: Int {
        
        return posts.likes
    }
    
    // if posts.likes is not equal to 1 then we return the number and likes, if it is equal to 1 then we return the number and like
    var likesLabelText: String {
        if posts.likes != 1 {
            
            return "\(posts.likes) likes"
        }else{
            
            return "\(posts.likes) like"
        }
    }
    
    var likeButtonTintColor: UIColor {
        
        return posts.didLike ? .red : .black
    }
    
    var likeButtonImage: UIImage? {
        
        let imageName = posts.didLike ? "like_selected" : "like_unselected"
        
        return UIImage(named: imageName)
    }
    
    
    init(post: Posts) {
        self.posts = post
        
    }
}
