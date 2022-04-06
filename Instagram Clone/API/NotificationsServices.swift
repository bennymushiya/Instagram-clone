//
//  NotificationsServices.swift
//  Instagram Clone
//
//  Created by benny mushiya on 18/02/2021.
//

import UIKit
import Firebase


struct NotificationsServices {
    
    
    /// the reason we make the post optional is because not all notifications comes with an a post. e.g if a user followed a user that means posts wont have a value.
    static func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Posts? = nil) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        // if the user trys to upload a notification to themselves they will hit this guard statement. that will say uid is the same as currentUser, lets not bother completing the code below and returns out of this function.
        guard uid != currentUser else {return}
        
        // we create an instance of our collection, then we collect its documentID they created for us.
        let docRef = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data = ["uid": fromUser.uid,
                    "timeStamp": Timestamp(date: Date()),
                    "type": type.rawValue,
                    "userProfileImageUrl": fromUser.profileImage,
                    "userName": fromUser.userName,
                    "docuID": docRef.documentID] as [String: Any]
        
        // if post exists were gonna be adding information to the data dictionary
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        docRef.setData(data)
        
 }
    
    
    static func fetchNotification(completion: @escaping([Notification]) -> Void) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        
        COLLECTION_NOTIFICATIONS.document(currentUser).collection("user-notifications").getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {return}
            
            let notifications = documents.map({Notification(dictionary: $0.data())})
            completion(notifications)
        }

        
    }
}
