//
//  CurrentUser.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/9/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//
import Firebase
import FirebaseDatabase


class User {
    var useremail: String?
    var username: String?
    var id: String?
    var ref: FIRDatabaseReference?
    
    init(username: String, useremail: String, id: String){
        self.username = username
        self.useremail = useremail
        self.id = id
        self.ref = FIRDatabase.database().reference()
    }
    
    init (snapshot: FIRDataSnapshot) {
        
        ref = snapshot.ref
        let data = snapshot.value as! Dictionary<String, String>
        useremail = data["useremail"]! as String
        username = data["username"]! as String
        id = data["id"]! as String
        
    }
    
    
}