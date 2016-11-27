//
//  constants.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/8/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Foundation
import Firebase
var currentUser : User?
var posts : [Post] = []
var activeContacts : [Contact] = []
var inactiveContacts : [Contact] = []
var displayContacts : [String] = []
var messages : [Message] = []
var userPosts : [Post] = []

let firebaseURL = "https://phoneafriend-7fb6b.firebaseio.com/"
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

typealias CompletionHandler = (success:Bool) -> Void
