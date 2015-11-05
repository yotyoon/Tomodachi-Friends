//
//  RSSViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 10/21/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit
import Parse

class RSSViewController: UITableViewController, MWFeedParserDelegate {
    
    var items = [MWFeedItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser()
        user.username = "my name"
        user.password = "my pass"
        user.email = "email@example.com"
        
        // other fields can be set if you want to save more information
        user["phone"] = "650-555-0000"
        
        user.signUpInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError == nil
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                //self.showAlert("There was an error with your sign up", error: returnedError!)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func request() {
        let URL = NSURL(string: "http://usjapantomodachi.org/feed/")
        let feedParser = MWFeedParser(feedURL: URL);
        feedParser.delegate = self
        feedParser.parse()
    }
    
    func feedParserDidStart(parser: MWFeedParser) {
        SVProgressHUD.show()
        self.items = [MWFeedItem]()
    }
    
    func feedParserDidFinish(parser: MWFeedParser) {
        SVProgressHUD.dismiss()
        self.tableView.reloadData()
    }
    
    
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        print(info)
        self.title = info.title
    }
    
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        print(item)
        self.items.append(item)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! RSSTableViewCell
        
        cell.ItemImageView.image = UIImage(named: "logo_100")
        let item = items[indexPath.row] as MWFeedItem?
        let pubDate = item?.date
        
        //format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .MediumStyle
        //dateFormatter.dateFormat = "hh:mm"
        let dateString = dateFormatter.stringFromDate(pubDate!)
        
        cell.ItemPubDateLabel.text = dateString
        cell.ItemTitleLabel.text = item?.title
        
        if item?.content != nil {
            
            let htmlContent = item!.content as NSString
            var imageSource = ""
            
            let rangeOfString = NSMakeRange(0, htmlContent.length)
            let regex = try? NSRegularExpression(pattern: "(<img.*?src=\")(.*?)(\".*?>)", options: [])
            
            if htmlContent.length > 0 {
                let match = regex?.firstMatchInString(htmlContent as String, options: [], range: rangeOfString)
                
                if match != nil {
                    let imageURL = htmlContent.substringWithRange(match!.rangeAtIndex(2)) as NSString
                    print(imageURL)
                    
                    if NSString(string: imageURL.lowercaseString).rangeOfString("feedburner").location == NSNotFound {
                        imageSource = imageURL as String
                    }
                    
                }
            }
            
            if imageSource != "" {
                cell.ItemImageView.setImageWithURL(NSURL(string: imageSource), placeholderImage: UIImage(named: "logo_100"))
            }else{
                cell.ItemImageView.image = UIImage(named: "logo_100")
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as MWFeedItem
        let con = KINWebBrowserViewController()
        let URL = NSURL(string: item.link)
        con.loadURL(URL)
        self.navigationController?.pushViewController(con, animated: true)
    }
    

}
