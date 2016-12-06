//
//  SessionBlackboardViewController
//  PhoneAFriend
//
//  Created by Michael Elliott on 12/3/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

var sessionController: SessionBlackboardViewController?

class SessionBlackboardViewController: UIViewController {
    
    var drawImage = UIImageView()
    var strokes: [Stroke] = []
    var currentStroke: Stroke!
    
    static var viewWidth = 667.0
    static var viewHeight = 375.0

    @IBAction func quitButtonTouched(sender: AnyObject) {
        print("Quit button pressed")
        twilioClient?.hangUp()
    }
    
    @IBAction func clearButtonTouched(sender: AnyObject) {
        print("Clear button pressed")
        sessionController?.clear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawImage.frame = view.bounds
        view.addSubview(drawImage)
        UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.LandscapeLeft.rawValue), forKey: "orientation")
        
        SessionBlackboardViewController.viewWidth = Double(self.view.frame.size.width)
        SessionBlackboardViewController.viewHeight = Double(self.view.frame.size.height)
        
        sessionController = self
        
        // If recipient, join the caller's session
        if (twilioClient!.callStatus == .Client) {
            print("Attempting to join session")
            Session.join()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = (touches.first! as UITouch).locationInView(view)
        currentStroke = newStroke()
        addPoint(currentStroke, point: point)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (currentStroke == nil) {
            return
        }

        let point = (touches.first! as UITouch).locationInView(view)
        addPoint(currentStroke, point: point)
    }
    
    func addPoint(stroke: Stroke, point: CGPoint) {
        stroke.points.append(CGPoint(x: point.x, y: point.y))
        
        if (stroke.lastPoint != nil) {
            UIGraphicsBeginImageContext(view.bounds.size)
            drawImage.image?.drawInRect(view.bounds)
            CGContextSetLineCap(UIGraphicsGetCurrentContext()!, .Round)
            CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, CGFloat(stroke.width))
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, 0, 0, 0, 1)
            CGContextBeginPath(UIGraphicsGetCurrentContext()!)
            CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, stroke.lastPoint!.x, stroke.lastPoint!.y)
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, point.x, point.y)
            CGContextStrokePath(UIGraphicsGetCurrentContext()!)
            drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        stroke.lastPoint = point
    }
    
    func newStroke() -> Stroke {
        let stroke = Stroke()
        strokes.append(stroke)
        
        return stroke
    }
    
    func addStroke(snapshot: FIRDataSnapshot) {
        let stroke = Stroke(snapshot: snapshot)
        strokes.append(stroke)
    }

    func clear() {
        strokes = []
        drawImage.image = nil
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentStroke.register()
        currentStroke.save()
    }
    
    /*override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (object as! CBLLiveQuery) == liveQuery {
            polylines.removeAll(keepCapacity: false)
            
            for (_, row) in liveQuery.rows.allObjects.enumerate() {
                polylines.append(Polyline(forDocument: (row as! CBLQueryRow).document))
            }
            
            drawPolylines()
        }
    }*/
    
    
    func drawBlackboard() {
        drawImage.image = nil
        UIGraphicsBeginImageContext(view.bounds.size)
        drawImage.image?.drawInRect(view.bounds)
        CGContextSetLineCap(UIGraphicsGetCurrentContext()!, .Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, 5.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, 0, 0, 0, 1)
        CGContextBeginPath(UIGraphicsGetCurrentContext()!)
        
        // Draw strokes
        for stroke in strokes {
            if let firstPoint = stroke.points.first {
                CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, firstPoint.x, firstPoint.y)
            }
            
            for point in stroke.points {
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, point.x, point.y)
            }
        }
        CGContextStrokePath(UIGraphicsGetCurrentContext()!)
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.LandscapeLeft
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    override func viewDidLayoutSubviews() {
        UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.LandscapeLeft.rawValue), forKey: "orientation")
    }
    
    // Return view to portrait when segueing out
    /*override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()) {
            UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.Portrait.rawValue), forKey: "orientation")
        }
    }*/
    
    // Force view to portrait
    func canRotate() -> Void {}
}
