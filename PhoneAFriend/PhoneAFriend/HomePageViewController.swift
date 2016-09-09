//
//  HomePageViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/9/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser!.name)
        print(currentUser!.email)
        print(currentUser!.uid)
    }
}
