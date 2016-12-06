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
    var width: Double
    var ref : FIRDatabaseReference?

    var points = [CGPoint]()
    var lastPoint: CGPoint?

    init (snapshot: FIRDataSnapshot) {
        ref = snapshot.ref
        let data = snapshot.value as! NSDictionary
        
        print("------------------")
        print("NEW STROKE: " + ref!.key)
        // Properties
        if let _color = data["color"] {
            color = (_color as AnyObject).integerValue
            print("Color: " + String(color))
        }
        else {
            color = 0
        }
        if let _data = data["width"] {
            width = (_data as AnyObject).doubleValue
            print("Width: " + String(width))
        }
        else {
            width = 4.0
        }

        // Get points in list ref
        let pointsRef = ref!.child("Points")
        var dataPoints = [CGPoint]()
        pointsRef.queryOrderedByKey().observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                print("Points: \(snapshot.childrenCount)")
                for pointsSnapshot in snapshot.children {
                    let pointSnapshot = pointsSnapshot as! FIRDataSnapshot
                    let pointData = pointSnapshot.value as! NSDictionary
                    
                    let x = (pointData["x"]! as AnyObject).doubleValue*SessionBlackboardViewController.viewWidth
                    let y = (pointData["y"]! as AnyObject).doubleValue*SessionBlackboardViewController.viewHeight
                    
                    dataPoints.append(CGPoint(x: x, y: y))
                }
                
                dataPoints = dataPoints.reverse()
                
                for point in dataPoints {
                    sessionController!.addPoint(self, point: point)
                }
            } else {
                print("Points: NONE")
            }
        })

    }

    init() {
        color = 0x000000
        width = 4
        self.ref = nil
    }

    func register() {
        self.ref = activeSession!.strokesRef!.childByAutoId()
    }
    
    func save() {
        // Properties
        let data = ["color": String(color),
                    "width": String(width)]
        ref!.updateChildValues(data)

        // Get points list ref
        let pointsRef = ref!.child("Points")
        
        // Points
        for point in points {
            // Get point info
            let pointData = ["x": String(Double(point.x)/SessionBlackboardViewController.viewWidth),
                             "y": String(Double(point.y)/SessionBlackboardViewController.viewHeight)]

            // Post point to database
            let pointRef = pointsRef.childByAutoId()
            pointRef.updateChildValues(pointData)
        }

        // Post to db (again)
        ref!.updateChildValues(data)
    }
    
    deinit {
        if self.ref != nil {
            ref?.removeValue()
        }
    }
}
