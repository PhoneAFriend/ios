//
//  Message.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/22/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Message {
    var sentBy: String!
    var sentTo: String!
    var subject: String!
    var message: String!
    var ref: FIRDatabaseReference!
    
    init (snapshot : FIRDataSnapshot) {
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        sentBy = data["sentBy"] as! String
        sentTo = data["sentTo"] as! String
        subject = data["subject"] as! String
        message = data["message"] as! String
    }
    
    init (ref: FIRDatabaseReference, sentBy : String, sentTo: String, subject: String, message: String) {
        self.ref = ref
        self.sentTo = sentTo
        self.sentBy = sentBy
        self.message = message
        self.subject = subject
    }
    
}
