//
//  Stroke.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/2/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Stroke {
    var color: String!
    var startPoint: Int!
    var endPoint: Int!
    var ref : FIRDatabaseReference

    
    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        color = data["color"] as! String
        startPoint = data["startPoint"] as! Int
        endPoint = data["endPoint"] as! Int
    }
}
