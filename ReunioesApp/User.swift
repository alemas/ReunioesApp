//
//  User.swift
//  ReunioesApp
//
//  Created by Mateus Reckziegel on 5/7/15.
//  Copyright (c) 2015 Mateus Reckziegel. All rights reserved.
//

import UIKit
import Parse
import Bolts

class User: NSObject {
    
    class func login(username:String, password:String, closure:(Bool)->Void) {
        
        if (PFUser.currentUser() == nil) {
            
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                
                if let usr:PFUser = user {
                    closure(true)
                } else {
                    closure(false)
                }
            })
        }
    }
    
    class func signUp(username:String, password:String, email:String, company:String, realName:String, closure:(Bool)->Void) {
        
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        user["company"] = company
        user["realName"] = realName

        user.signUpInBackgroundWithBlock{(succeeded, error) -> Void in
         
            if error == nil {
                closure(true)
            } else {
                closure(false)
            }
            
        }
        
    }
    
    class func getMeetings() -> NSArray {
        
        if (User.getCurrentUser() == nil){
            return []
        }
        
        let query = PFQuery(className: "Meeting")
        query.whereKey("attendee", equalTo: User.getCurrentUser()!)
        
        var array = NSArray()
        
        query.findObjectsInBackgroundWithBlock{(objects, error) -> Void in
            array = objects!
        }
        
        if array.count>0 {
            
            var meetingsArray = NSMutableArray()
        
            for o in array {
            
                let obj = o as! PFObject
                
                let meeting = Meeting(subject: obj["subject"] as! String,
                    creator: obj["creator"] as! PFUser,
                    attendee: obj["attendee"] as! NSArray,
                    address: obj["address"] as! String,
                    date: obj["date"] as! NSDate,
                    tolerance: obj["tolerance"] as! Int)
                
                meetingsArray.addObject(meeting)
            
            }
            
            return meetingsArray
        }
        
        return array
    }
    
    class func logout(closure:(Bool) -> Void) {
        PFUser.logOutInBackgroundWithBlock({(error) -> Void in
            
            if error == nil {
                closure(true)
            } else {
                closure(false)
            }
            
        })
    }
    
    class func getCurrentUser() -> PFUser? {
        return PFUser.currentUser()
    }
    
}
