//
//  DataService.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/28/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

//self.ref.child("users").child(user.uid).setValue(["username": username])

class DataService {
    static let instance = DataService()
    
    private var _REF_DATABASE: FIRDatabaseReference
    private var _REF_POSTS: FIRDatabaseReference
    private var _REF_USERS: FIRDatabaseReference
    private var _REF_STORAGE: FIRStorageReference
    private var _REF_IMAGES: FIRStorageReference
    
    var REF_BASE : FIRDatabaseReference {
        return _REF_DATABASE
    }
    
    var REF_POSTS : FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS : FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_STORAGE : FIRStorageReference {
        return _REF_STORAGE
    }
    
    var REF_IMAGES : FIRStorageReference {
        return _REF_IMAGES
    }
    
    private init() {
        _REF_DATABASE = FIRDatabase.database().reference()
        _REF_POSTS = _REF_DATABASE.child("posts")
        _REF_USERS = _REF_DATABASE.child("users")
        _REF_STORAGE = FIRStorage.storage().reference(forURL: "gs://anthonywhitakershowcase.appspot.com")
        _REF_IMAGES = _REF_STORAGE.child("images")
    }
    
    func createFireBaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).setValue(user)
    }
    
    //TODO: Add completion handler for errors & updating UI
    func createPost(postDescription: String, postImage: Data?) {
        let postRef = REF_POSTS.childByAutoId()
        let postKey = postRef.key
        
        var imageUrl: URL? = nil
        
        if let postImage = postImage {
            imageUrl = DataService.instance.save(image: postImage, as: postKey)
            if imageUrl == nil {
                 // Image did not upload correctly. Throw error.
            }
        }
        
        let post = Post(username: "Bob the Tester", description: postDescription, imageUrl: imageUrl?.absoluteString)
        postRef.setValue(post.asDictionary)
    }
    
    //TODO: Add completion handler for errors
    func save(image: Data, as postKey: String) -> URL? {
        let imageRef = REF_IMAGES.child("\(postKey).jpg")
        var downloadUrl: URL? = nil
        imageRef.put(image, metadata: nil, completion: { metadata, error in
            if let error = error {
                print(error) // We have a problem
            } else if let metadata = metadata {
                downloadUrl = metadata.downloadURL()
            }
        })
        return downloadUrl
    }
}
