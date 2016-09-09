//
//  CurrentUser.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/9/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

class CurrentUser {
    var name: String?
    var email: String?
    var uid: String?
    
    init(name: String, email: String, uid: String) {
        self.name = name
        self.email = email
        self.uid = uid
    }
}
