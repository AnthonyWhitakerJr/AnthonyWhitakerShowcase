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
import FirebaseAuth

//self.ref.child("users").child(user.uid).setValue(["username": username])

class DataService {
    static let instance = DataService()
    
    private(set) var REF_DATABASE: FIRDatabaseReference
    private(set) var REF_POSTS: FIRDatabaseReference
    private(set) var REF_USERS: FIRDatabaseReference
    private(set) var REF_STORAGE: FIRStorageReference
    private(set) var REF_IMAGES: FIRStorageReference
    private(set) var REF_IMAGES_POSTS: FIRStorageReference
    private(set) var REF_IMAGES_PROFILES: FIRStorageReference
    
    /// Database reference for current user's data. Returns `nil` if user is not logged in.
    var REF_USER_CURRENT: FIRDatabaseReference? {
        let uid = FIRAuth.auth()?.currentUser?.uid
        if let uid = uid {
            return REF_USERS.child(uid)
        }
        
        return nil
    }
    
    private init() {
        REF_DATABASE = FIRDatabase.database().reference()
        REF_POSTS = REF_DATABASE.child("posts")
        REF_USERS = REF_DATABASE.child("users")
        REF_STORAGE = FIRStorage.storage().reference(forURL: "gs://anthonywhitakershowcase.appspot.com")
        REF_IMAGES = REF_STORAGE.child("images")
        REF_IMAGES_POSTS = REF_IMAGES.child("posts")
        REF_IMAGES_PROFILES = REF_IMAGES.child("profiles")
    }
    
    func createFireBaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).setValue(user)
    }
    
    //TODO: Add completion handler for errors & updating UI
    //TODO: Remove code duplication.
    func createPost(postDescription: String, postImage: Data?) {
        let postRef = REF_POSTS.childByAutoId()
        let postKey = postRef.key
        
        if let postImage = postImage {
            save(postImage: postImage, as: postKey, completion: { url, error in
                if let error = error {
                    print(error) // Image did not upload correctly.
                } else if let url = url {
                    let post = Post(username: "Bob the Tester", description: postDescription, imageUrl: url.absoluteString)
                    postRef.setValue(post.asDictionary)
                }
            })
        } else {
            let post = Post(username: "Bob the Tester", description: postDescription, imageUrl: nil)
            postRef.setValue(post.asDictionary)
        }
    }
    
    func isLikedByCurrentUser(post: Post, completion: @escaping (_: Bool) -> ()){
        let likeRef = REF_USER_CURRENT?.child("likes").child(post.postKey)
        likeRef?.observeSingleEvent(of: .value , with: { snapshot in
            let value = snapshot.value as? Bool
            let ans = value == nil ? false : value!
            completion(ans)
        })
    }

    
    // FIXME: Corruptable by concurrent mods. Implement transaction block.
    func updateLikes(for post: Post, wasLiked: Bool) {
        let userLikeRef = DataService.instance.REF_USER_CURRENT?.child("likes").child(post.postKey)
        if wasLiked {
            userLikeRef?.setValue(true)
            REF_POSTS.child(post.postKey).child(Post.DataKey.likes.rawValue).setValue(post.likes + 1)
        } else {
            userLikeRef?.removeValue()
            REF_POSTS.child(post.postKey).child(Post.DataKey.likes.rawValue).setValue(post.likes - 1)
        }
    }
    
    func save(profileImage image: Data, as profileKey: String, completion: @escaping (_ url: URL?,_ error: Error?) -> ()) {
        save(image: image, as: profileKey, storageRef: REF_IMAGES_PROFILES, completion: { url, error in completion(url, error)})
    }
    
    func save(postImage image: Data, as postKey: String, completion: @escaping (_ url: URL?,_ error: Error?) -> ()) {
        save(image: image, as: postKey, storageRef: REF_IMAGES_POSTS, completion: { url, error in completion(url, error)})
    }

    
    func save(image: Data, as key: String, storageRef: FIRStorageReference, completion: @escaping (_ url: URL?,_ error: Error?) -> ()) {
        let imageRef = storageRef.child("\(key).jpg")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.put(image, metadata: metadata, completion: { metadata, error in
            if let error = error {
                completion(nil, error)
            } else if let metadata = metadata {
                completion(metadata.downloadURL(),nil)
            }
        })
    }
}
