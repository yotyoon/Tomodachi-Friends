//
//  AboutPageViewController.swift
//  TOMODACHI
//
//  Created by Kei Fujisato on 11/7/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeButtonTapped(sender: AnyObject) {
        
        //Navigate to protected page
        let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let settingPage:SettingViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        
        let settingPageNav = UINavigationController(rootViewController: settingPage)
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = settingPageNav

    }
    
    
    
}
