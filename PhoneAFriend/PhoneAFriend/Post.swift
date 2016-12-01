//
//  Post.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/16/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//
import Firebase
import FirebaseDatabase

class Post {
    var questionTitle : String?
    var questionText : String?
    var questionImageURL : String?
    var datePosted : String?
    var subject : String?
    var postedBy : String?
    var answered : String?
    var ref: FIRDatabaseReference?
    var key:String
    
    init (snapshot: FIRDataSnapshot) {
        key = snapshot.key
        ref = snapshot.ref
        let data = snapshot.value as! Dictionary<String, String>
        questionTitle = data["questionTitle"]! as String
        questionText = data["questionText"]! as String
        questionImageURL = data["questionImageURL"]! as String
        datePosted = data["datePosted"]! as String
        subject = data["subject"]! as String
        postedBy = data["postedBy"]! as String
        answered = data["answered"]! as String
        
    }
    
}

