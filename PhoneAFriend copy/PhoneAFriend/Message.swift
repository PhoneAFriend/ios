//
//  Message.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/22/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Message {
    var senderUsername: String!
    var recipientUsername: String!
    var subject: String!
    var message: String!
    var unread: Bool!
    var postKey: String!
    var ref: FIRDatabaseReference!
    
    init (snapshot : FIRDataSnapshot) {
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        senderUsername = data["senderUsername"] as! String
        recipientUsername = data["recipientUsername"] as! String
        subject = data["subject"] as! String
        message = data["message"] as! String
        unread = data["unread"] as! Bool
        if (data["postKey"] != nil){
            postKey = data["postKey"] as! String
        }
        
    }
    
    init (senderUsername : String, recipientUsername: String, subject: String, message: String, unread: Bool, postKey: String) {
        self.recipientUsername = recipientUsername
        self.senderUsername = senderUsername
        self.message = message
        self.subject = subject
        self.unread = unread
        self.postKey = postKey
    }
    
}
