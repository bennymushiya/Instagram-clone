//
//  CommentsViewModel.swift
//  Instagram Clone
//
//  Created by benny mushiya on 17/02/2021.
//

import UIKit


struct CommentsViewModel {
    
    private var comments: Comments
    
    
    var commentText: String {
        
        return comments.commentText
    }
    
    var profileImage: URL? {
        
        return URL(string: comments.profileImageUrl)
    }
    
    
    init(comments: Comments) {
        self.comments = comments
        
    }
    
    /// determines the dynamic sizes for each cell, e.g if the comment is really long this function will figure out the sizing for that single cell.
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comments.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
}
