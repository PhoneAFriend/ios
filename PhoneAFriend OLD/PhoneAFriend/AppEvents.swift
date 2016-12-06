//
//  AppEvents.swift
//  PhoneAFriend
//
//  Created by Michael Elliott on 12/4/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class AppEvents {
    
    static var loadingOverlay: UIAlertController?
    
    static func showLoadingOverlay(message: String) {
        loadingOverlay = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        
        // Show dialing indicator
        loadingOverlay!.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        // Show alert
        loadingOverlay!.view.addSubview(loadingIndicator)
        getTopmostViewController()!.presentViewController(loadingOverlay!, animated: true, completion: nil)
    }
    
    static func hideLoadingOverlay() {
        loadingOverlay?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    static func getTopmostViewController() -> UIViewController? {
        
        // Find root view controller
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        // Recursively find topmost view controller
        if (topController != nil) {
            while (topController!.presentedViewController != nil) {
                topController = topController!.presentedViewController
            }
        }
        
        return topController
    }
}
