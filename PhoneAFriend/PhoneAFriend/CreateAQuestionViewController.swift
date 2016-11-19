//
//  CreateAQuestionViewController.swift
//
//
//  Created by Cody Miller on 9/12/16.
//
//

import UIKit
import Firebase

class CreateAQuestionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var questionTitleField: UITextField!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    var selectedPicker : String = ""
    override func viewDidLoad(){
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        
        pickerData = ["Math", "Math", "Math"]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         selectedPicker = pickerData[row]
    }
    
    @IBAction func postQuestion(sender: AnyObject) {
        //Add checking functions to throw alerts if the user has not filled in all the data fields. 
        //Add checking function to see if the user upload an image. if so, call a save function to get the url of the saved image in firebase, otherwise, send an empty url string
        print(selectedPicker)
        let post = Post(questionTitle: questionTitleField.text!, questionText: questionTextField.text!, questionImageURL: "www.fakeurl.com", datePosted: "fakedatefornow", subject: selectedPicker, postedBy: currentUser!.username!, answered: "false")
        posts.append(post)
        saveNewPost(questionTitleField.text!, questionText: questionTextField.text!, questionImageURL: "fakeUrl", datePosted: "fakedate", subject: selectedPicker, postedBy: currentUser!.username!, answered: "false")
    }
    
    func saveNewPost(questionTitle: String, questionText: String, questionImageURL : String, datePosted : String, subject : String, postedBy : String, answered : String){
        let firebaseRef = FIRDatabase.database().reference()
        
        let key = firebaseRef.child("posts").childByAutoId().key
        
        let newPost = ["postedBy" : postedBy,
                       "questionText" : questionText,
                       "questionTitle" : questionTitle,
                       "questionImageURL" : questionImageURL,
                       "datePosted" : datePosted,
                       "subject" : subject,
                       "answered" : answered
        ]
        
        let childUpdates = ["/posts/\(key)": newPost]
        firebaseRef.updateChildValues(childUpdates)
    }

}
