//
//  TabBarViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 10/24/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.whiteColor()
        self.tabBar.barTintColor = UIColor(netHex: 0x2196f3)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Selected)

    }
}
