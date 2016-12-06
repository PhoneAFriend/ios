//
//  Stroke.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/2/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase

class Stroke {
    var color: Int
    var width: Int
    var ref : FIRDatabaseReference?

    var points = [CGPoint]()

    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        color = data["color"] as! Int
        width = data["width"] as! Int
    }

    init() {
        color = 0x000000
        width = 4
        ref = nil
    }
}
