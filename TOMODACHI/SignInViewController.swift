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
                NSUserDefaults.standardUserDefaults().setObject(userNameValue, forKey: "user_name")
                NSUserDefaults.standardUserDefaults().synchronize()
                
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
    /*    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
