//
//  LoginViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 10/27/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /*     if (PFUser.currentUser() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = [.UsernameAndPassword, .LogInButton, .PasswordForgotten, .SignUpButton, .Facebook, .Twitter]
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            self.presentViewController(loginViewController, animated: false, completion: nil)
        } else {
             self.initialiseLogin()
        }*/

     if (PFUser.currentUser() == nil){
            let loginViewController = PFLogInViewController()
            
            loginViewController.fields = [PFLogInFields.UsernameAndPassword,
                PFLogInFields.LogInButton, PFLogInFields.SignUpButton,
                PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton]
            
            loginViewController.delegate = self
            
            let signupViewController = PFSignUpViewController()
            signupViewController.delegate = self
            
            loginViewController.signUpController = signupViewController
            self.presentViewController(loginViewController, animated: true, completion: nil)

        }
      else{
        self.initialiseLogin()
        }

      
    }
    
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if(!username.isEmpty || !password.isEmpty) {
            return true
        }else{
            return false
        }
        
    }

    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.initialiseLogin()
    }

    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.initialiseLogin()
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Fail to login")
    }
    
    
    
    //MARK: Parse Sign Up
    func initialiseLogin()
    {
          let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: UITabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarMain") as! UITabBarController
            self.presentViewController(vc, animated: false, completion: nil)
       
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("fail to sign up...")
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        print("User dismissed sign up")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
