//
//  Post.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/28/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import Foundation

class Post {

    enum DataKey: String {
        case username
        case description
        case imageUrl
        case likes
        case uid
        case timestamp
    }
    
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
            DataKey.username.rawValue: username,
            DataKey.description.rawValue: postDescription,
            DataKey.likes.rawValue: likes
//            DataKey.timestamp.rawValue: timestamp,
//            DataKey.uid.rawValue: uid
        ]
        
        if hasImage {
            result[DataKey.imageUrl.rawValue] = imageUrl
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
        let username = data[DataKey.username.rawValue] as? String
        let description = data[DataKey.description.rawValue] as? String
        let imageUrl = data[DataKey.imageUrl.rawValue] as? String
        let likes = data[DataKey.likes.rawValue] as? Int
        
        if let username = username, let description = description, let likes = likes {
            self.init(username: username, description: description, imageUrl: imageUrl, likes: likes)
            self._postKey = postKey
        } else {
            return nil
        }
    }
    
    

}
