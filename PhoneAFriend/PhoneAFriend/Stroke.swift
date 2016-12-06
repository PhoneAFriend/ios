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

    init(ref: FIRDatabaseReference) {
        color = 0x000000
        width = 4
        self.ref = ref
    }

    func save() -> Dictionary<String, String> {
        // Properties
        let data = ["color": String(color),
                    "width": String(width)]
        ref!.updateChildValues(data)

        // Get points list ref
        let pointsRef = ref!.child("Points")

        // Points
        for point in points {
            // Get point info
            let pointData = ["x": String(point.x/100),
                             "y": String(point.y/100)]

            // Post point to database
            let pointRef = pointsRef.childByAutoId()
            pointRef.updateChildValues(pointData)
        }
        return data
    }
}
