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

    init(ref: FIRDatabaseReference, senderName: String, recipientName: String, postRef: String) {
        
        self.ref = ref
        self.senderName = senderName
        self.recipientName = recipientName
        self.postRef = postRef
    }
    
    static func create(recipientName: String, postRef: String) -> String {
        // Post a new session to Firebase
        let ref = FIRDatabase.database().reference().child("Sessions").childByAutoId()
        let senderName = currentUser!.username!
        
        // Create a reference to the session
        activeSession = Session(ref: ref, senderName: senderName, recipientName: recipientName, postRef: postRef)
        
        // Fill in the session details
        let post = ["senderName": senderName,
                    "recipientName": recipientName,
                    "postRef": postRef,
                    "strokes": []]
        activeSession!.updateSession(activeSession!.ref, post: post)
    
        return ref.key;
    }
    
    func updateSession(sessionRef: FIRDatabaseReference, post: NSDictionary) {
        let childUpdates = ["/Sessions/\(sessionRef.key)":post]
        FIRDatabase.database().reference().updateChildValues(childUpdates)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadPosts", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadUserPosts", object: nil)
    }
}
