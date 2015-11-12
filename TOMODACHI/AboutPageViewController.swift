//
//  AboutPageViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 11/7/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       let localFilePath = NSBundle.mainBundle().URLForResource("aboutUs", withExtension: "html")
        let request = NSURLRequest(URL: localFilePath!)
        webView.loadRequest(request)
        self.view.addSubview(webView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
