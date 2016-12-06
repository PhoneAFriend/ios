//
//  Upvote.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/6/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Upvote {
    
    var username: String
    var answerKey: String
    var ref: FIRDatabaseReference
    
    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        let data = snapshot.value as! Dictionary<String, String>
        username = data["username"]!
        answerKey = data["answerKey"]!
    }
    
}
