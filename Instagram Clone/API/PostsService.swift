//
//  PostsService.swift
//  Instagram Clone
//
//  Created by benny mushiya on 16/02/2021.
//

import UIKit
import Firebase


/// if we didnt make our functions inside the struct static then, we would have to create an instance of this struct everytime, before we call the functions inside.
struct PostsService {
    
    
    /// when we create functions to upload things. the input parameters should usaully be anything based in the UI, that we dont have access to is what our input parameters should be.
    static func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        
        // only the current signed user can upload a post thats why we get their uid
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
    
    ImageUploader.uploadImage(image: image) { imageUrl in
        
        let data = ["caption": caption,
                    "timeStamp": Timestamp(date: Date()),
                    "likes": 0,
                    "imageUrl": imageUrl,
                    "ownerImageUrl": user.profileImage,
                    "ownerUserName": user.userName,
        "ownerUid": currentUser] as [String : Any]
        
        COLLECTION_POSTS.addDocument(data: data, completion: completion)
        
    }
        
}
    
    /// we fetch each posts the user has posted by timeStamp, based on the time it was posted.
    static func fetchPosts(completion: @escaping([Posts]) -> Void) {
        
        COLLECTION_POSTS.order(by: "timeStamp", descending: true).getDocuments { snapshot, error in
            
            // passes all the documents inside the snapshot to that property.
            guard let documents = snapshot?.documents else {return}
            
            // maps all of our data into our posts model and we grab the docID from each post inside the dataBase.
            let posts = documents.map({Posts(postId: $0.documentID, dictionary: $0.data())})
            
            completion(posts)
        }
    }
    
    
}
