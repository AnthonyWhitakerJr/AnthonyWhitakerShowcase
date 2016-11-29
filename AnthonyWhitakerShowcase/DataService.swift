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
    
    func save(image: Data, with postKey: String) -> URL? {
        let imageRef = REF_IMAGES.child(postKey)
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
    
    func save(image: URL, with postKey: String) -> URL? {
        let imageRef = REF_IMAGES.child(postKey)
        var downloadUrl: URL? = nil
        imageRef.putFile(image, metadata: nil, completion: { metadata, error in
            if let error = error {
                print(error) // We have a problem
            } else if let metadata = metadata {
                downloadUrl = metadata.downloadURL()
            }
        })
        return downloadUrl
    }
}
