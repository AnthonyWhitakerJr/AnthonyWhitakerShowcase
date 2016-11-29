//
//  Post.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/28/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription: String
    private var _imageUrl: String?
    private var _likes: Int
    private var _username: String // XXX: Should probably be uid.
    private var _postKey: String!
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var likes: Int {
        return _likes
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
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
