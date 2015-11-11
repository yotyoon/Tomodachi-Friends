//
//  SettingViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 11/7/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit
import Parse

class SettingViewController: UIViewController{

    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadUserDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().stringForKey("user_name")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Sending"
        spiningActivity.detailsLabelText = "Please wait"
        
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            
            spiningActivity.hide(true)
            
            //Navigate to protected page
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let signInPage:SignInViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
            
            let signInPageNav = UINavigationController(rootViewController: signInPage)
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = signInPageNav
            
        }
        

    }
    
    
    func loadUserDetails()
    {
        if(PFUser.currentUser() == nil)
        {
            return
        }
        
        let userFirstName = PFUser.currentUser()?.objectForKey("first_name") as? String
        
        if userFirstName == nil
        {
            return
        }
        
        let userLastName = PFUser.currentUser()?.objectForKey("last_name") as! String
        
        userFullNameLabel.text = userFirstName! + " " + userLastName
        
        let profilePictureObject = PFUser.currentUser()?.objectForKey("profile_picture") as? PFFile
        
        if(profilePictureObject != nil)
        {
            profilePictureObject!.getDataInBackgroundWithBlock { (imageData:NSData?, error:NSError?) -> Void in
                
                if(imageData != nil)
                {
                    self.userProfilePicture.image = UIImage(data: imageData!)
                }
                
            }
        }
        
    }

    @IBAction func editButtonTapped(sender: AnyObject) {
        
        let editProfile = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        editProfile.opener = self
        
        let editProfileNav = UINavigationController(rootViewController: editProfile)
        
        self.presentViewController(editProfileNav, animated: true, completion: nil)
  
    }

}
