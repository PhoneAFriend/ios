//
//  ContactViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/2/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var NavView: UIView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var startASessionButton: UIButton!
    @IBOutlet weak var unfriendButton: UIButton!
    var contact : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        contactView.layer.cornerRadius = 10
        unfriendButton.layer.cornerRadius = 10
        messageButton.layer.cornerRadius = 10
        startASessionButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        if contact != nil {
            usernameLabel.text = contact
        }
        let maskPath = UIBezierPath(roundedRect: contactView.bounds,
                                    byRoundingCorners: [.TopLeft, .TopRight],
                                    cornerRadii: CGSize(width: 10.0, height: 10.0))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.CGPath
        NavView.layer.mask = shape
    }

    @IBAction func donePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messagePressed(sender: AnyObject) {
    }

    @IBAction func unfriendPressed(sender: AnyObject) {
    }
 
    @IBAction func startSessionPressed(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
