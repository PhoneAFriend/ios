//
//  Post.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/16/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//
import Firebase

class Post {
    var questionTitle : String?
    var questionText : String?
    var questionImageURL : String?
    var datePosted : String?
    var subject : String?
    var postedBy : String?
    var answered : String?
    
    init(questionTitle: String, questionText: String, questionImageURL : String, datePosted : String, subject : String, postedBy : String, answered : String){
        
        self.questionTitle = questionTitle
        self.questionText = questionText
        self.questionImageURL = questionImageURL
        self.datePosted = datePosted
        self.subject = subject
        self.postedBy = postedBy
        self.answered = answered
        
    }
    
}