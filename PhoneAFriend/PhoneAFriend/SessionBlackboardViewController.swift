//
//  SessionBlackboardViewController
//  PhoneAFriend
//
//  Created by Michael Elliott on 12/3/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class SessionBlackboardViewController: UIViewController {
    
    var drawImage = UIImageView()
    var strokes: [Stroke] = []
    var currentStroke: Stroke!
    var lastPoint: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawImage.frame = view.bounds
        view.addSubview(drawImage)
        
        /*liveQuery = kDatabase.createAllDocumentsQuery().asLiveQuery()
        liveQuery.addObserver(self, forKeyPath: "rows", options: [], context: nil)
        do {
            try liveQuery.run()
        } catch {
         
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastPoint = (touches.first! as UITouch).locationInView(view)
        currentStroke = Stroke()
        currentStroke.points.append(CGPoint(x: lastPoint.x, y: lastPoint.y))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = (touches.first! as UITouch).locationInView(view)
        currentStroke.points.append(CGPoint(x: point.x, y: point.y))
        
        UIGraphicsBeginImageContext(view.bounds.size)
        drawImage.image?.drawInRect(view.bounds)
        CGContextSetLineCap(UIGraphicsGetCurrentContext()!, .Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext()!, 5.0)
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext()!, 0, 0, 0, 1)
        CGContextBeginPath(UIGraphicsGetCurrentContext()!)
        CGContextMoveToPoint(UIGraphicsGetCurrentContext()!, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext()!, point.x, point.y)
        CGContextStrokePath(UIGraphicsGetCurrentContext()!)
        drawImage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = point
    }
    
    // Not for use
    @IBAction func clear(sender: AnyObject) {
        for stroke in strokes {
            do {
                //try stroke.deleteDocument()
            } catch {
                
            }
        }
        strokes = []
        drawImage.image = nil
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        do {
            //try currentPolyline.save()
        } catch {
            
        }
        
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

}
