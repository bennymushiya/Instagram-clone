//
//  ImageUploader.swift
//  Instagram Clone
//
//  Created by benny mushiya on 12/02/2021.
//

import UIKit
import FirebaseStorage


struct ImageUploader {
    
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let fileName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference(withPath: "profile_images \(fileName)jpg")
        
        storageRef.putData(imageData, metadata: nil) { snapshot, error in
            if let error = error {
                
                print("failed to upload image \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    
                    print("failed to download into url")
                    return
                }
                
                guard let imageUrl = url?.absoluteString else {return}
                
                completion(imageUrl)
            }
            
        }
        
        
    }
    
    
    
}
