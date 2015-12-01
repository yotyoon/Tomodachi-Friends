
//
//  SignInViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 11/5/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit


class SignInViewController: UIViewController {


    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        if(userEmail!.isEmpty || userPassword!.isEmpty)
        {
            let myAlert = UIAlertController(title: "Alert", message: "Please provide Email address and password to sign in.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            myAlert.addAction(okAction)
            
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Sending"
        spiningActivity.detailsLabelText = "Please wait"
        PFUser.logInWithUsernameInBackground(userEmail!, password: userPassword!) { (user:PFUser?, error:NSError?) -> Void in
            
            spiningActivity.hide(true)
            
            var userMessage = "Welcome to Tomodacahi."
            if(user != nil)
            {
                //Remember the sign in state
                let userNameValue:String? = user?.username
                NSUserDefaults.standardUserDefaults().setObject(userNameValue, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                let installation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackgroundWithBlock(nil)
                
                //Navigate to protected page
                let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
                let tabMainPage:UITabBarController = mainStoryBoard.instantiateViewControllerWithIdentifier("TabBarMain") as! UITabBarController
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = tabMainPage
  
            }else{
                userMessage = error!.localizedDescription
                
                let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
            }
            
        }
    }
    
    @IBAction func facebookButtonTapped(sender: AnyObject) {
        
        // Create Permissions array
        let permissions = ["public_profile","email","user_friends"]
        
        // Login to Facebook with Permissions
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions, block: { (user:PFUser?, error:NSError?) -> Void in
            
            // If error, display message
            if(error != nil)
            {
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    let userMessage = error!.localizedDescription
                    let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    return
                } // end of async
            }
            
            
            // Load facebook user details like user First name, Last name and email address
            self.loadFacebookUserDetails()
            
        })
        
    }
    
    func loadFacebookUserDetails()
    {
        
        // Show activity indicator
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Loading"
        spiningActivity.detailsLabelText = "Please wait"
        
        
        // Define fields we would like to read from Facebook User object
        let requestParameters = ["fields": "id, email, first_name, last_name, name"]
        
        // Send Facebook Graph API Request for /me
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        userDetails.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            
            
            
            if error != nil {
                
                // Display error message
                spiningActivity.hide(true)
                
                let userMessage = error!.localizedDescription
                let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
                
                PFUser.logOut()
                
                return
            }
            
            
            // Extract user fields
            let userId:String = result["id"] as! String
            let userEmail:String? = result["email"] as? String
            let userFirstName:String?  = result["first_name"] as? String
            let userLastName:String? = result["last_name"] as? String
            
            
            
            // Get Facebook profile picture
            let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
            
            let profilePictureUrl = NSURL(string: userProfile)
            
            let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
            
            
            // Prepare PFUser object
            if(profilePictureData != nil)
            {
                let profileFileObject = PFFile(data:profilePictureData!)
                PFUser.currentUser()?.setObject(profileFileObject, forKey: "profile_picture")
            }
            
            PFUser.currentUser()?.setObject(userFirstName!, forKey: "first_name")
            PFUser.currentUser()?.setObject(userLastName!, forKey: "last_name")
            
            
            
            if let userEmail = userEmail
            {
                PFUser.currentUser()?.email = userEmail
                PFUser.currentUser()?.username = userEmail
            }
            
            
            
            PFUser.currentUser()?.saveInBackgroundWithBlock({ (success, error) -> Void in
                
                spiningActivity.hide(true)
                
                if(error != nil)
                {
                    let userMessage = error!.localizedDescription
                    let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    
                    myAlert.addAction(okAction)
                    
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                    
                    PFUser.logOut()
                    return
                    
                    
                }
                
                
                if(success)
                {
                    if !userId.isEmpty
                    {
                        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "username")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        
                        let installation = PFInstallation.currentInstallation()
                        installation["user"] = PFUser.currentUser()
                        installation.saveInBackgroundWithBlock(nil)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.buildUserInterface()
                        }
                        
                    }
                    
                }
                
            })
            
            
        })
    }
    
    
  }
