//
//  ProfileCellViewModel.swift
//  Instagram Clone
//
//  Created by benny mushiya on 17/02/2021.
//

import UIKit

struct ProfileCellViewModel {
    
    var posts: Posts
    
    var profileImage: URL? {
        
        return URL(string: posts.imageUrl)
    }
    
    
    init(posts: Posts) {
        self.posts = posts
        
        
    }
    
}
