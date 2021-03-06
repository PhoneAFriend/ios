//
//  CreateAQuestionViewController.swift
//
//
//  Created by Cody Miller on 9/12/16.
//
//

import UIKit
import AVFoundation
import Firebase

class CreateAQuestionViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var image : UIImage! = nil
    var questionTitle = ""
    var subject = ""
    var question = ""
    var imagePicker:UIImagePickerController!
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let captureSession = AVCaptureSession()
    var imageURL : String = "None"
    var postKey = ""

    @IBOutlet weak var questionTitleTextField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var subjectTextField: UITextField!

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    var subjectOption = ["Math", "Science", "Computer Science", "Writing", "Other"]

    override func viewDidLoad(){
        self.hideKeyboardWhenTappedAround()

        self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0)

        super.viewDidLoad()
        let pickerView = UIPickerView()
        questionTextView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 0)

        pickerView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        subjectTextField.inputView = pickerView
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectTextField.text = subjectOption[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func postPress(sender: AnyObject) {

        questionTitle = questionTitleTextField.text!
        subject = subjectTextField.text!
        question = questionTextView.text
        if questionTitle != "" && subject != "" && question != "" {

            startSave(questionTitle, username: currentUser!.username!, questionText: question, subject: subject)

        } else {
            let alert = UIAlertController(title: "Can not post", message: "You did not fill in all necessary fields", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            })
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    

    func saveImage(imageName: String, image: UIImage, completion : (result:Bool) -> ()){
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let imagedata = UIImageJPEGRepresentation(image, 0.8)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child("images/\(postKey)").putData(imagedata!, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                completion(result: false)
            }else{
                //consider doing an update to an alred posted post here to make it run quicker?
                self.imageURL = metaData!.downloadURL()!.absoluteString!
                completion(result: true)
            }
        }
    }
    
    func startSave(questionTitle: String, username: String, questionText: String, subject: String) {

        postKey = FIRDatabase.database().reference().child("posts").childByAutoId().key
        if image == nil {
            imageURL = "None"
            let post = ["answered": "false",
                        "datePosted": "Need to configure",
                        "postedBy": username,
                        "questionImageURL" :imageURL,
                        "questionText" : questionText,
                        "questionTitle" : questionTitle,
                        "subject" : subject,
                        "postKey" : self.postKey]

            saveNewPost(post)
        } else {
            AppEvents.showLoadingOverlay("Posting...")
            let imageName = currentUser!.username! + (questionTitleTextField.text?.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: ""))!
            saveImage(imageName, image:  image) { (boolValue) -> Void in
                if boolValue {
                    let post = ["answered": "false",
                                "datePosted": "Need to configure",
                                "postedBy": username,
                                "questionImageURL" :self.imageURL,
                                "questionText" : questionText,
                                "questionTitle" : questionTitle,
                                "subject" : subject,
                                "postKey" : self.postKey]
                    AppEvents.hideLoadingOverlay()
                    self.saveNewPost(post)

                } else {
                    print("an error occured", terminator: "")

                }
            }
        }
        

    }
    func saveNewPost(post: NSDictionary) {
        let childUpdates = ["/posts/\(postKey)":post]
        FIRDatabase.database().reference().updateChildValues(childUpdates)
        //NSNotificationCenter.defaultCenter().postNotificationName("reloadPosts", object: nil)
        //NSNotificationCenter.defaultCenter().postNotificationName("reloadUserPosts", object: nil)

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func capturePressed(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imageCaptureInit(imagePicker)
    }
    @IBAction func addPressed(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePickerInit(imagePicker)
    }
    @IBAction func addImagePressed(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePickerInit(imagePicker)
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }


}
