//
//  Constants.swift
//  Instagram Clone
//
//  Created by benny mushiya on 13/02/2021.
//

import Foundation
import Firebase


let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")
