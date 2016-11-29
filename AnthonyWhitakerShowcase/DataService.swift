//
//  DataService.swift
//  AnthonyWhitakerShowcase
//
//  Created by Anthony Whitaker on 11/28/16.
//  Copyright © 2016 Anthony Whitaker. All rights reserved.
//

import Foundation
import FirebaseDatabase

//self.ref.child("users").child(user.uid).setValue(["username": username])

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE: FIRDatabaseReference!
    private var _REF_POSTS: FIRDatabaseReference!
    private var _REF_USERS: FIRDatabaseReference!
    
    var REF_BASE : FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS : FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS : FIRDatabaseReference {
        return _REF_USERS
    }
    
    private init() {
        _REF_BASE = FIRDatabase.database().reference()
        _REF_POSTS = _REF_BASE.child("posts")
        _REF_USERS = _REF_BASE.child("users")
    }
    
    func createFireBaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).setValue(user)
    }
}
