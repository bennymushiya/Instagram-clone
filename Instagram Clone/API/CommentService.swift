//
//  CommentService.swift
//  Instagram Clone
//
//  Created by benny mushiya on 17/02/2021.
//

import UIKit
import Firebase


struct CommentService {
    
    
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion)) {
        
        let data = ["uid": user.uid,
                    "comment": comment,
                    "timeStamp": Timestamp(date: Date()),
                    "userName": user.userName,
                    "profileImageUrl": user.profileImage] as [String: Any]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
        
        
    }
    
    /// fetches the uploaded comments imedtiatly and displays it in front of the UI, but it does this striaght away, in real time.
    static func fetchComments(forPost postID: String, completion: @escaping([Comments]) -> Void) {
        
        var comments = [Comments]()
        
        let query = COLLECTION_POSTS.document(postID).collection("comments").order(by: "timeStamp", descending: true)
        
        // adds a real time update/fetch data immediately.
        query.addSnapshotListener { snapshot, error in
            
            // we  look at the document changes and we loop through them.
            snapshot?.documentChanges.forEach({ Change in
                
                // if something was added to the dataBase
                if Change.type == .added {
                    
                    // we pass that changed data to our property and create our comment
                    let data = Change.document.data()
                    let comment = Comments(dictionary: data)
                    
                    comments.append(comment)
                }
            })
            
            completion(comments)
        }
        
    }
    
}

