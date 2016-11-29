//
//  Post.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/28/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _likes: Int!
    private var _username: String!
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
    
    //
    init(username: String, description: String, imageUrl: String? = nil, likes: Int = 0) {//, postKey: String) {
        _username = username
        _postDescription = description
        _imageUrl = imageUrl
        _likes = likes
//        _postKey = postKey // ????
    }
    
    //FIXME: Does not handle incomplete or corrupt data.
    init(postKey: String, data: Dictionary<String, Any>) {
        if let description = data["description"] as? String {
            self._postDescription = description
        }
        
        self._imageUrl = data["imageUrl"] as? String
        
        if let likes = data["likes"] as? Int {
            self._likes = likes
        }
        
        if let username = data["username"] as? String {
            self._username = username
        }
        
        self._postKey = postKey
    }

}
