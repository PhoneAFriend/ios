//
//  Contact.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/16/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Contact {
    var u12: Bool!
    var u21: Bool!
    var username1: String!
    var username2: String!
    var ref : FIRDatabaseReference!
    
    // snapshot used to translate contacts after they are pulled from the firebase DB
    
    init (snapshot: FIRDataSnapshot) {
        
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        u12 = data["u12"]! as! Bool
        u21 = data["u21"]! as! Bool
        username1 = data["username1"]! as! String
        username2 = data["username2"]! as! String
        
    }
    
    // this initializer is used when contact is added locally
    
    init (u12: Bool, u21: Bool, username1: String, username2: String) {
        
        self.u12 = u12
        self.u21 = u21
        self.username1 = username1
        self.username2 = username2
        
    }
    
    
}