//
//  PasswordResetViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 11/9/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit

class PasswordResetViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
        let emailAddress = emailAddressTextField.text
        
        if(emailAddress!.isEmpty)
        {
            let userMessage:String = "please type in your email address"
            self.displayMessage(userMessage)
            return
        }
        
    PFUser.requestPasswordResetForEmailInBackground(emailAddress!) { (success:Bool, error:NSError?) -> Void in
            if(error != nil)
            {
               //Display error message
                let userMessage:String = error!.localizedDescription
                self.displayMessage(userMessage)
                
            }else{
              //Display success message
                let userMessage:String =
                "An email message was sent to you \(emailAddress)"
                self.displayMessage(userMessage)
        }
        }
    }
    
    func displayMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.Default) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated:true, completion:nil)
   
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }

}
