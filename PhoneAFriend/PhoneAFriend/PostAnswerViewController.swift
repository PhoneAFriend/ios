//
//  PostAnswerViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/28/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class PostAnswerViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var captureImageButton: UIButton!
    var imagePicker:UIImagePickerController!
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let captureSession = AVCaptureSession()
    var imageURL : String = "None"
    var image : UIImage! = nil
    var answerKey : String = ""
    var key : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0)
        self.hideKeyboardWhenTappedAround()
        self.automaticallyAdjustsScrollViewInsets = false
        self.textView.delegate = self
    }
 
    @IBAction func postPressed(sender: AnyObject) {
        if textView.text != "" {
            AppEvents.showLoadingOverlay("Posting Answer...")
            
            answerKey = FIRDatabase.database().reference().child("answers").childByAutoId().key
            if image == nil {
                imageURL = "None"
                let answer = ["upvotes": 0,
                              "postedBy": currentUser!.username!,
                              "answerImageURL" :imageURL,
                              "answerText" : textView.text,
                              "key" : key
                ]
                saveToDB(answer)
            } else {
                saveImage(image) { (boolValue) -> Void in
                    if boolValue {
                        let answer = ["upvotes": 0,
                                      "postedBy": currentUser!.username!,
                                      "answerImageURL" :self.imageURL,
                                      "answerText" : self.textView.text,
                                      "key" : self.key
                        ]
                        AppEvents.hideLoadingOverlay()
                        self.saveToDB(answer)
                    } else {
                        print("It done went and broke", terminator: "")
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "No answer text was added. Add text and submit again.", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in })
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePickerInit(imagePicker)
    }

    
    @IBAction func captureImagePressed(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imageCaptureInit(imagePicker)
    }

    
    func imagePickerInit(imagePicker: UIImagePickerController){
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imageCaptureInit(imagePicker: UIImagePickerController) {
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }

    
    func saveImage(image: UIImage, completion : ( result:Bool) -> ()){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let imagedata = UIImageJPEGRepresentation(image, 0.8)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child("images/\(answerKey)").putData(imagedata!, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                completion(result: false)
            }else{
                self.imageURL = metaData!.downloadURL()!.absoluteString!
                completion(result: true)
            }
        }
    }
    func saveToDB(answer: NSDictionary) {

        let childUpdates = ["/answers/\(answerKey)":answer]
        FIRDatabase.database().reference().updateChildValues(childUpdates)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadAnswers", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
