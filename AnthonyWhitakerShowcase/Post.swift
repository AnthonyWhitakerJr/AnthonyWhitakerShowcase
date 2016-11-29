//
//  Post.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/28/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import Foundation

class Post {

    private var _imageUrl: String?
    private var _likes: Int
    private var _postDescription: String
    private var _postKey: String!
    private var _timestamp: Int!
    private var _uid: String!
    private var _username: String // TODO: Should be replaced by uid
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postDescription: String {
        return _postDescription
    }
    
    var postKey: String {
        return _postKey
    }
    
    var timestamp: Int {
        return _timestamp
    }
    
    var uid: String {
        return _uid
    }
    
    var username: String {
        return _username
    }
    
    var hasImage: Bool {
        return imageUrl != nil
    }
    
    var asDictionary: Dictionary<String, Any> {
        var result: Dictionary<String, Any> = [
            "username": username,
            "description": postDescription,
            "likes": likes
//            "timestamp": timestamp,
//            "uid": uid
        ]
        
        if hasImage {
            result["imageUrl"] = imageUrl
        }
        
        return result
    }
    
    init(username: String, description: String, imageUrl: String? = nil, likes: Int = 0) {//, postKey: String) {
        _username = username
        _postDescription = description
        _imageUrl = imageUrl
        _likes = likes
//        _postKey = postKey // ????
    }
    
    
    /// Used to create a Post based on an entry in Firebase database.
    /// - returns `nil` if data is incomplete, corrupt or malformed.
    convenience init?(postKey: String, data: Dictionary<String, Any>) {
        let username = data["username"] as? String
        let description = data["description"] as? String
        let imageUrl = data["imageUrl"] as? String
        let likes = data["likes"] as? Int
        
        if let username = username, let description = description, let likes = likes {
            self.init(username: username, description: description, imageUrl: imageUrl, likes: likes)
            self._postKey = postKey
        } else {
            return nil
        }
    }
    
    

}
