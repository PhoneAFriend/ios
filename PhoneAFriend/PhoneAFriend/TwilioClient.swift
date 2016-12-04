//
//  TwilioClient.swift
//  PhoneAFriend
//
//  Created by Michael Elliott on 12/3/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TwilioClient: NSObject, TCDeviceDelegate, TCConnectionDelegate {
    
    var serverURL = ""
    
    var device: TCDevice?
    var connection: TCConnection?

    //MARK: Initialization methods
    
    static func configure() {
    
        /*FIRDatabase.database().reference().child("TwilioServerURL").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.childrenCount != 0 {
                for data in snapshot.children {
                    twilioClient!.serverURL = snapshot.value![0]
                    print(twilioClient)
                }
            }
        })
        print("Connecting to \(twilioClient!.serverURL)")*/
        
        twilioClient = TwilioClient()
        twilioClient!.retrieveToken()
    }
    
    func initializeTwilioDevice(token:String) {
        device = TCDevice.init(capabilityToken: token, delegate: self)
        
        //self.dialButton.enabled = true
    }

    func retrieveToken() {
        // Get server URL from Firebase
        FIRDatabase.database().reference().child("TwilioServer").queryOrderedByChild("url")
            .observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                let data = snapshot.value as! Dictionary<String, String>
                self.serverURL = data["url"]!
                print("Twilio server identified as " + self.serverURL)

                // Create a GET request to the capability token endpoint
                let session = NSURLSession.sharedSession()

                let url = NSURL(string: self.serverURL + "token/" + currentUser!.username!)
                let request = NSURLRequest(URL: url!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30.0)

                let task = session.dataTaskWithRequest(request) { (responseData:NSData?, response:NSURLResponse?, error:NSError?) in
                    if let responseData = responseData {
                        do {
                            let responseObject = try NSJSONSerialization.JSONObjectWithData(responseData, options:[])
                            
                            if let identity = responseObject["identity"] as? String{
                                dispatch_async(dispatch_get_main_queue()) {
                                    print("TwilioClient registered as \"\(identity)\"")
                                }
                            }
                            
                            if let token = responseObject["token"] as? String {
                                self.initializeTwilioDevice(token)
                            }
                        } catch let error {
                            print("Error: \(error)")
                        }
                    } else if let error = error {
                        self.displayError(error.localizedDescription)
                    }
                }
                task.resume()
            })
    }
    
    //MARK: Utility Methods
    
    func displayError(errorMessage:String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        
        AppEvents.getTopmostViewController()?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: TCDeviceDelegate
    
    func device(device:TCDevice, didStopListeningForIncomingConnections:NSError?) {
        if let error = didStopListeningForIncomingConnections {
            print("Stopped listening for incoming connections: " + error.localizedDescription)
        }
    }
    
    func deviceDidStartListeningForIncomingConnections(device: TCDevice) {
        print("Started listening for incoming connections")
    }
    
    func device(device: TCDevice, didReceiveIncomingConnection connection: TCConnection) {
        if let parameters = connection.parameters {

            let from = parameters["From"]
            let message = "Incoming call from \(from)"
            let alertController = UIAlertController(title: "Incoming Call", message: message, preferredStyle: .Alert)
            let acceptAction = UIAlertAction(title: "Accept", style: .Default, handler: { (action:UIAlertAction) in
                connection.delegate = self
                connection.accept()
                self.connection = connection
            })
            let declineAction = UIAlertAction(title: "Decline", style: .Cancel, handler: { (action:UIAlertAction) in
                connection.reject()
            })
            alertController.addAction(acceptAction)
            alertController.addAction(declineAction)
            
            AppEvents.getTopmostViewController()?.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    //MARK: TCConnectionDelegate
    func connection(connection: TCConnection, didFailWithError:NSError?) {
        if let error = didFailWithError {
            print(error.localizedDescription)
        }
    }
    
    func connectionDidStartConnecting(connection: TCConnection) {
        //statusLabel.text = "Started connecting...."
    }
    
    func connectionDidConnect(connection: TCConnection) {
        // Transition to session view
        let storyBoard : UIStoryboard = UIStoryboard(name: "Session", bundle:nil)
        
        let resultViewController = storyBoard.instantiateInitialViewController()
        
        AppEvents.getTopmostViewController()?.presentViewController(resultViewController!, animated:true, completion:nil)
    }
    
    func connectionDidDisconnect(connection: TCConnection) {
        // Do nothing
    }
    
    //MARK: UITextFieldDelegate
    /*func textFieldShouldReturn(textField: UITextField) -> Bool {
        dial(dialTextField)
        dialTextField.resignFirstResponder()
        return true;
    }*/

    // Stop dialing
    @IBAction func hangUp() {
        if (device != nil) {
            device!.disconnectAll()
        }
    }

    // Begin dialing by username
    func dial(contactName: String, sessionRefString: String) {
        if (device != nil) {
            device!.connect(["To" : contactName, "Session" : sessionRefString], delegate: self)
            print("Dialing \"\(contactName)\"...");
        }
    }
    
    // Begin dialing and show dialing popup
    func dialUser(currentViewController: UIViewController, contactName: String, sessionRefString: String) {
        /*
         * Begin dialing
         */
        dial(contactName, sessionRefString: sessionRefString);

        /*
         * Show dialing overlay
         */
        let alert = UIAlertController(title: nil, message: "Dialing...", preferredStyle: .Alert)
        
        // Show dialing indicator
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        // Show cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            self.hangUp()
        })
        alert.addAction(cancel)
        
        // Show alert
        alert.view.addSubview(loadingIndicator)
        currentViewController.presentViewController(alert, animated: true, completion: nil)
    }
}
