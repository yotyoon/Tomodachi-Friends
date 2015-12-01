//
//  MessagesViewController.swift
//  TOMODACHI
//
//  Created by Yot Yoon Toh on 11/28/15.
//  Copyright © 2015 Yot Yoon Toh. All rights reserved.
//

import UIKit

class MessagesViewController: JSQMessagesViewController {
    
    var room:PFObject!
    var incomingUser:PFUser!
    var users = [PFUser]()
    
    var messages = [JSQMessage]()
    var messageObjects = [PFObject]()
    
    var outgoingBubbleImage:JSQMessagesBubbleImage!
    var incomingBubbleImage:JSQMessagesBubbleImage!
    
    var selfAvatar:JSQMessagesAvatarImage!
    var incomingAvatar:JSQMessagesAvatarImage!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Messages"
        self.senderId = PFUser.currentUser()!.objectId
        self.senderDisplayName = PFUser.currentUser()!.username
        
        self.inputToolbar!.contentView!.leftBarButtonItem = nil
        
        let selfUsername = PFUser.currentUser()!.username! as NSString
        let incomingUsername = incomingUser.username! as NSString
        
        selfAvatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(selfUsername.substringWithRange(NSMakeRange(0, 2)), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(incomingUsername.substringWithRange(NSMakeRange(0, 2)), backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(14), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        outgoingBubbleImage = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.blueColor())
        incomingBubbleImage = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
                     
        loadMessages()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadMessages", name: "reloadMessages", object: nil)
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadMessages", object: nil)
    }

    
    
    //MARK: - Load Messages
    func loadMessages(){
        var lastMessage:JSQMessage? = nil
        
        if messages.last != nil {
            lastMessage = messages.last
        }
        
        
        let messageQuery = PFQuery(className: "Message")
        messageQuery.whereKey("room", equalTo: room)
        messageQuery.orderByAscending("createdAt")
        messageQuery.limit = 500
        messageQuery.includeKey("user")
        
        if lastMessage != nil {
            messageQuery.whereKey("createdAt", greaterThan: lastMessage!.date)
        }
        
        
        messageQuery.findObjectsInBackgroundWithBlock { (NSArray results, NSError error) in
            
            if error == nil {
                let messages = results as! [PFObject]
                
                for message in messages{
                    self.messageObjects.append(message)
                    
                    let user = message["user"] as! PFUser
                    self.users.append(user)
                    
                    let chatMessage = JSQMessage(senderId: user.objectId, senderDisplayName: user.username, date: message.createdAt, text: message["content"] as! String)
                    self.messages.append(chatMessage)
                }
            }
            if results!.count != 0 {
                self.finishReceivingMessage()
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Send Messages
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        let message = PFObject(className: "Message")
        message["content"] = text
        message["room"] = room
        message["user"] = PFUser.currentUser()
        
        message.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if error == nil {
                self.loadMessages()
                let pushQuery = PFInstallation.query()
                pushQuery!.whereKey("user", equalTo: self.incomingUser)
                
                let push = PFPush()
                push.setQuery(pushQuery)
                
                let pushDict = ["alert":text,"badge":"increment","sound":"notification.caf"]
                
                push.setData(pushDict)
                
                push.sendPushInBackgroundWithBlock(nil)
                
                self.room["lastUpdate"] = NSDate()
                self.room.saveInBackgroundWithBlock(nil)
            }else{
                 print("error sending message \(error!.localizedDescription)")
            }
        }
        self.finishSendingMessage()
    }
    
    // MARK: - DELEGATE METHODS
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            return outgoingBubbleImage
        }
        
        return incomingBubbleImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            return selfAvatar
        }
        
        return incomingAvatar
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.row]
        
        if message.senderId == self.senderId {
            cell.textView!.textColor = UIColor.blackColor()
        }else{
            cell.textView!.textColor = UIColor.whiteColor()
        }
        
        cell.textView!.linkTextAttributes = [NSForegroundColorAttributeName:cell.textView!.textColor!]
        
        return cell
        
    }
    
    
    // MARK: - DATASOURCE
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }


}
