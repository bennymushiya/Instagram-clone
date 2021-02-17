//
//  AuthService.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit
import Firebase


struct AuthCredentials {
    let name: String
    let username: String
    let email: String
    let password: String
    let profileImage: UIImage
    
}

struct AuthService {
    
    /// logs user in
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping(Error?) -> Void) {
        
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { results, error in
                
                if let error = error {
                    
                    print("failed to upload all the data lad \(error.localizedDescription)")
                    return
                    
                }
                
                guard let uid = Auth.auth().currentUser?.uid else {return}
                
                let data = ["uid": uid,
                            "name": credentials.name,
                            "userName": credentials.username,
                            "email": credentials.email,
                            "profileImage": imageUrl]  as [String: Any]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
            
        }
        
        
        
    }
    
    
    
}
