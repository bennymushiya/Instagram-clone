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
            
            // passes all the documents inside the snapshot to the created instance.
            guard let documents = snapshot?.documents else {return}
            
            // maps all of our data into our posts model and we grab the docID from each post inside the dataBase.
            let posts = documents.map({Posts(postId: $0.documentID, dictionary: $0.data())})
            
            completion(posts)
        }
    }
    
    /// its only going to fetch the posts that is the same as the current users uid.
    static func fetchPostsForUser(forUser uid: String, completion: @escaping(([Posts]) -> Void)) {
        
        let query = COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            print("docuemnt is \(documents)")
            
            var posts = documents.map({Posts(postId: $0.documentID, dictionary: $0.data())})
            
            // sorts out the post by timeStamp
            posts.sort { (post1, post2) -> Bool in
                
                return post1.timeStamp.seconds > post2.timeStamp.seconds
            }
            
            completion(posts)
        }
        
    }
    
    static func fetchPost(withPostId postId: String, completion: @escaping(Posts) -> Void) {
        
        COLLECTION_POSTS.document(postId).getDocument { (snapshot, error) in
            
            guard let document = snapshot else {return}
            
            guard let data = document.data() else {return}
            
            let post = Posts(postId: document.documentID, dictionary: data)
            
            completion(post)
        }
        
    }
    
    /// increments the likes post field, each time a user likes a post by 1 and adds the user uid to post-likes collection to show which user liked that specific posts. also goes into the current User collection and creates a user-likes collection and adds the post ID of that liked post.
    static func likePost(post: Posts, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(currentUser).setData([:]) { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
        
    }
    
    
    static func unlikePost(post: Posts, completion: @escaping(FirestoreCompletion)) {

        guard let currentUser = Auth.auth().currentUser?.uid else {return}

        // before we unlike a post we make sure its greater than 0, if not then it might crash, if it goes into minus numbers.
        guard post.likes > 0 else {return}
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(currentUser).delete { _ in
            
            COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postId).delete(completion: completion)
        }
        
    }
    
    /// we go into our user-likes collection and we determine whether the specific postID exist, if it does then didLike will return true else it will return false because it doesnt exist.
    static func checkIfUserLikedPost(post: Posts, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}

        COLLECTION_USERS.document(currentUser).collection("user-likes").document(post.postId).getDocument { snapshot, error in
            
            guard let didLike = snapshot?.exists else {return}
            
            completion(didLike)
        }
        
    }
    
}
