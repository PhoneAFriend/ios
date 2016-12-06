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
    
    var live = false
    
    var ref: FIRDatabaseReference?
    var strokesRef: FIRDatabaseReference?
    
    init(snapshot: FIRDataSnapshot){
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        recipientName = data["recipientName"] as! String
        postRef = data["postRef"] as! String
        senderName = data["senderName"] as! String
        
        strokesRef = ref!.child("Strokes")
    }

    init(ref: FIRDatabaseReference, senderName: String, recipientName: String, postRef: String) {
        
        self.ref = ref
        self.senderName = senderName
        self.recipientName = recipientName
        self.postRef = postRef
        self.live = true
        
        strokesRef = ref.child("Strokes")
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
                    "Strokes": []]
        activeSession!.updateSession(post)
        activeSession!.beginListening()

        return ref.key;
    }

    static func join() {

        var sessions = [Session]()

        FIRDatabase.database().reference().child("Sessions").queryOrderedByChild("recipientName").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for sessionSnapshot in snapshot.children {
                    let session = Session(snapshot: sessionSnapshot as! FIRDataSnapshot)
                    sessions.append(session)
                }
            }
            sessions = sessions.reverse()

            // Get newest session with the user marked as the recipient
            for session in sessions {
                if session.recipientName == currentUser?.username {
                    activeSession = session
                    activeSession!.beginListening()
                    activeSession!.live = true
                    print("Joining session")
                    return
                }
            }
            
            print("ERROR: Could not join session")
        })
    }
    
    
    func beginListening() {
        
        // Listen for new strokes
        strokesRef!.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            print("Stroke received")
            sessionController!.addStroke(snapshot)
        })
        
        // Listen for erasures
        strokesRef!.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            print("Stroke removed; clearing all strokes")
            sessionController!.clear()
        })
    }
    
    func updateSession(post: NSDictionary) {
        let childUpdates = ["/Sessions/\(ref!.key)":post]
        FIRDatabase.database().reference().updateChildValues(childUpdates)
    }
    
    // End the session and return to the menus
    deinit {
        if live {
            print("Active session was deleted; returning to menus")
            
            // Go back to menus
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let resultViewController = storyBoard.instantiateInitialViewController()
            
            AppEvents.getTopmostViewController()?.presentViewController(resultViewController!, animated:true, completion:nil)
        }
    }
}
