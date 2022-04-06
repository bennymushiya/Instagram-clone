//
//  UserService .swift
//  Instagram Clone
//
//  Created by benny mushiya on 13/02/2021.
//

import UIKit
import Firebase

typealias FirestoreCompletion = (Error?) -> Void

struct UserService {
    
    /// fetches only one user, based on the userID we put in we grab that specific users data, whether its current user, nor another user thats commented or liked a post .
    static func fetchUser(withUser userID: String, completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(userID).getDocument { snapshot, error  in
            
            // dot data represents the document in a dictionary format 
            guard let dictionary = snapshot?.data() else {return}
            
            let user = User(dictionary: dictionary)
            
            completion(user)
            
        }
        
    }
    
    /// fetches all the users inside the database
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        
        COLLECTION_USERS.getDocuments { snapshot, error in
            
            guard let snapshots = snapshot else {return}
            
            // we go into the documents and look at the documents that we need, then its going to map each user into an array. the $0 means each one of the document data is being added into an array.
            let users = snapshots.documents.map({User(dictionary: $0.data())})
            completion(users)
        }
        
    }
    
    /// adds the documents uid of the user that followed another user and saves it to the database.
    static func followUser(uid: String, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        // we go into the document and set the user.uid of the user that decided to follow a specific users./ we add this to the list of people that the user is following
        COLLECTION_FOLLOWING.document(currentUser).collection("user-following").document(uid).setData([:]) { error in
            
            // we add this to the list of users that are following our current user.
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUser).setData([:], completion: completion)
            
        }
        
    }
    
    /// unfollows the users, upon click
    static func unFollowUser(uid: String, completion: @escaping(FirestoreCompletion)) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}

        COLLECTION_FOLLOWING.document(currentUser).collection("user-following").document(uid).delete { error in
            
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUser).delete(completion: completion)
            
        }
        
    }
    
    /// checks if the user is already following another user.
    static func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}

        COLLECTION_FOLLOWING.document(currentUser).collection("user-following").document(uid).getDocument { snapshot, error in
            
            // if snapshot does exist, then isFollowed will be true, if it doesnt then it will be false.
            guard let isFollowed = snapshot?.exists else {return}
            
            completion(isFollowed)
        }
        
    }
    
    /// fetches the stats of the user. e.g the amount of users they have liked, the amount of users thats liked them and also the posts they have posted.
    static func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, error in
            
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { snapshot, error in
                
                let following = snapshot?.documents.count ?? 0
                
                COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { (snapshot, error) in
                    
                    let posts = snapshot?.documents.count ?? 0
                    
                    let stats = UserStats(followers: followers, following: following, posts: posts)
                    
                    completion(stats)
                    
                }
                
                
            }
        }
        
    }
    
}
