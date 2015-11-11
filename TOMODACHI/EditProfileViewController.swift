//
//  EditProfileViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 11/10/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    var opener:SettingViewController!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load user details
        let userFirstName = PFUser.currentUser()?.objectForKey("first_name") as! String
        let userLastName = PFUser.currentUser()?.objectForKey("last_name") as! String
        
        firstNameTextField.text = userFirstName
        lastNameTextField.text = userLastName
        
        if(PFUser.currentUser()?.objectForKey("profile_picture") != nil)
        {
            let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                
                if(imageData != nil)
                {
                    self.profilePictureImageView.image = UIImage(data: imageData!)
                }
                
            })
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        // Get current user
        let myUser:PFUser = PFUser.currentUser()!
        
        // Get profile image data
        let profileImageData = UIImageJPEGRepresentation(profilePictureImageView.image!, 1)
        
        // Check if all fields are empty
        if(passwordTextField.text!.isEmpty && firstNameTextField.text!.isEmpty && lastNameTextField.text!.isEmpty && (profileImageData == nil))
        {
            
            let myAlert = UIAlertController(title:"Alert", message:"All fields cannot be empty", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated:true, completion:nil);
            return
        }
        
        // If user decided to update their password make sure there is no typo
        if(!passwordTextField.text!.isEmpty && (passwordTextField.text != repeatPasswordTextField.text))
        {
            let myAlert = UIAlertController(title:"Alert", message:"Passwords do not match", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated:true, completion:nil);
            
            return;
        }
        
        // Check if First name and Last name are not empty
        if(firstNameTextField.text!.isEmpty || lastNameTextField.text!.isEmpty)
        {
            
            let myAlert = UIAlertController(title:"Alert", message:"First name and Last name are required fields", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated:true, completion:nil);
            
            return
        }
        
        // Set new values for user first name and last name
        let userFirstName = firstNameTextField.text
        let userLastName = lastNameTextField.text
        
        myUser.setObject(userFirstName!, forKey: "first_name")
        myUser.setObject(userLastName!, forKey: "last_name")
        
        // set new password
        if(!passwordTextField.text!.isEmpty)
        {
            let userPassword = passwordTextField.text
            myUser.password = userPassword
        }
        
        
        // Set profile picture
        if(profileImageData != nil)
        {
            let profileFileObject = PFFile(data:profileImageData!)
            myUser.setObject(profileFileObject!, forKey: "profile_picture")
        }
        
        // Display activity indicator
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Please wait"
        
        myUser.saveInBackgroundWithBlock { (success, error) -> Void in
            
            // Hide activity indicator
            loadingNotification.hide(true)
            
            if(error != nil)
            {
                
                let myAlert = UIAlertController(title:"Alert", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                
                return
            }
            
            
            if(success)
            {
                
                let userMessage = "Profile details successfully updated"
                let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction!) -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        self.opener.loadUserDetails()
                    })
                    
                })
                
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                
            }
          
        }
   
    }
    
    @IBAction func doneEditProfile(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    @IBAction func editProfilePictureTapped(sender: AnyObject) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        profilePictureImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
