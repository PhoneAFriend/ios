//
//  PostImageViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/24/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase


class PostImageViewController : UIViewController {
    var imageURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageURL != "" {
            startDownload()
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    func startDownload(){
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }        
        }
    }
    
}
