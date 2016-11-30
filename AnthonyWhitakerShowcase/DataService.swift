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
    
    private var _REF_DATABASE: FIRDatabaseReference
    private var _REF_POSTS: FIRDatabaseReference
    private var _REF_USERS: FIRDatabaseReference
    private var _REF_STORAGE: FIRStorageReference
    private var _REF_IMAGES: FIRStorageReference
    private var _REF_IMAGES_POSTS: FIRStorageReference
    private var _REF_IMAGES_PROFILES: FIRStorageReference

    
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
    
    var REF_IMAGES_POSTS : FIRStorageReference {
        return _REF_IMAGES_POSTS
    }
    
    var REF_IMAGES_PROFILES : FIRStorageReference {
        return _REF_IMAGES_PROFILES
    }
    
    /// Database reference for current user's data. Returns `nil` if user is not logged in.
    var REF_USER_CURRENT: FIRDatabaseReference? {
        let uid = FIRAuth.auth()?.currentUser?.uid
        if let uid = uid {
            return REF_USERS.child(uid)
        }
        
        return nil
    }
    
    private init() {
        _REF_DATABASE = FIRDatabase.database().reference()
        _REF_POSTS = _REF_DATABASE.child("posts")
        _REF_USERS = _REF_DATABASE.child("users")
        _REF_STORAGE = FIRStorage.storage().reference(forURL: "gs://anthonywhitakershowcase.appspot.com")
        _REF_IMAGES = _REF_STORAGE.child("images")
        _REF_IMAGES_POSTS = _REF_IMAGES.child("posts")
        _REF_IMAGES_PROFILES = _REF_IMAGES.child("profiles")
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
    
    func isLikedByCurrentUser(post: Post) -> Bool {
        var result = false
        let likeRef = DataService.instance.REF_USER_CURRENT?.child("likes").child(post.postKey)
        print(likeRef!.url)
//        likeRef?.observeSingleEvent(of: .value , with: { snapshot in
//            if let value = snapshot.value as? Bool {
//                print(value)
//                result = value
//            }
//        })
        
        isLiked(ref: likeRef!, completion: {ans in result = ans})
        print("\(post.postKey) is liked: \(result)")
        return result
    }
    
    func isLikedByCurrentUser(post: Post, completion: @escaping (_: Bool) -> ()){
        let likeRef = DataService.instance.REF_USER_CURRENT?.child("likes").child(post.postKey)
        print(likeRef!.url)
                likeRef?.observeSingleEvent(of: .value , with: { snapshot in
                    let value = snapshot.value as? Bool
                    let ans = value == nil ? false : value!
                    completion(ans)
                })
    }
    
    func isLiked(ref: FIRDatabaseReference, completion: @escaping (_ : Bool)->()) {
        ref.observeSingleEvent(of: .value , with: { snapshot in
            if let value = snapshot.value as? Bool {
                print(value)
                completion(value)
            }
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
