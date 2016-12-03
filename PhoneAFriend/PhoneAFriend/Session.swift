//
//  Session.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/2/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Session {
    var recipientName: String!
    var senderName: String!
    var postRef: String!
    var strokes: [Stroke]!
    var ref: FIRDatabaseReference
    
    init(snapshot: FIRDataSnapshot){
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        recipientName = data["recipientName"] as! String
        postRef = data["postRef"] as! String
        senderName = data["senderName"] as! String
        print(data["strokes"])
    }
}
