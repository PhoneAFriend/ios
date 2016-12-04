//
//  Answer.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/28/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Answer {
    
    var postedBy: String
    var key : String
    var answerImageURL : String
    var answerText  : String
    var upvotes : Int
    var ref : FIRDatabaseReference
    
    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        postedBy = data["postedBy"] as! String
        key = data["key"] as! String
        answerImageURL = data["answerImageURL"] as! String
        answerText = data["answerText"] as! String
        upvotes = data["upvotes"] as! Int
    }
    
}
