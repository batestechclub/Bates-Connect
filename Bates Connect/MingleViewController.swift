//
//  ViewController.swift
//  Mingle
//
//  Created by Loaner on 4/27/15.
//  Copyright (c) 2015 Tuan Nguyen. All rights reserved.
//

import UIKit
import AudioToolbox

class MingleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let jsonConvoListURL = "https://bobcatmingle.firebaseio.com/convoIDList.json"
    private let rootRef = Firebase(url: "https://bobcatmingle.firebaseio.com/")
    private let IDListRef = Firebase(url: "https://bobcatmingle.firebaseio.com/convoIDList")
    private let allChatsRef = Firebase(url: "https://bobcatmingle.firebaseio.com/allChats")
    var chatRef: Firebase?
    
    private var maxEmpty: Int = 2
    private var chat = [Dictionary <String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let maxEmptyRef = rootRef.childByAppendingPath("maxEmpty")
        maxEmptyRef.observeEventType(.Value, withBlock: { snapshot in
            if let someInt = snapshot.value as? Int
            {
                self.maxEmpty = someInt
                println("Maximum number of empty rooms: \(self.maxEmpty)")
            }
        })
        tableView.delegate = self
        tableView.dataSource = self
        sendButton.enabled = false
        leaveButton.enabled = false
        
        //Handle keyboard appearing and disappearing + move view accordingly
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:"))
        tableView.addGestureRecognizer(gestureRecognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
        
        //Table View setup
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRectZero) //hide empty cells
        
        //Check for user agreement
        if defaults.integerForKey("userHasAgreed") != 1
        {
            println("Setting up user agreement")
            setupUserAgreement()
        }
        else
        {
            IAgreeButton.hidden = true
        }
        
    }
    
    func playAlert()
    {
        var localNotification = UILocalNotification()
        //localNotification.fireDate = NSDate(timeIntervalSinceNow: 0.1)
        localNotification.alertAction = "In chat!"
        localNotification.alertBody = "Mingle: You are now in chat."
        //localNotification.timeZone =
        //localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        localNotification.soundName = UILocalNotificationDefaultSoundName // play default sound
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    //MARK: Chat Handling
    func browseConvo() -> String
    {
        var convoKeyArray = [String]()
        var message = "no key found"
        
        var parseError: NSError?
        var convoNameData = NSData(contentsOfURL: NSURL(string: jsonConvoListURL)!)! as NSData //possible error
        var convoArray: AnyObject? = NSJSONSerialization.JSONObjectWithData(convoNameData, options: NSJSONReadingOptions.MutableContainers, error: &parseError)
        
        if parseError != nil
        {
            println("Error in parsing JSON data to dictionary")
            return message
        }
        else
        {
            for aKey in convoArray!.allKeys
            {
                if let sizeInt = convoArray!.objectForKey(aKey) as? Int
                {
                    if sizeInt == 1
                    {
                        convoKeyArray.append(aKey as! String)
                    }
                }
            }
            
            if convoKeyArray.count < self.maxEmpty
            {
                message = "too few users"
                return message
            }
            let randomInt = Int(arc4random_uniform(UInt32(convoKeyArray.count)))
            message = convoKeyArray[randomInt]
        }
        return message
    }
    
    func addNewConvo()
    {
        println("Adding new convo...")
        var convoIDRef = IDListRef.childByAutoId()
        convoIDRef.setValue(1 as Int)
        //sleep(1)
        
        //setup the location for the conversation with that key
        let convoKey = convoIDRef.key
        println("Creating key \(convoKey)")
        chatRef = allChatsRef.childByAppendingPath(convoKey)
        chatRef!.setValue("convo created.")
        println("waiting for people to join...")
        statusLabel.text = "Status: Waiting for people to join..."
        
        userName = "Red"
        IDListRef.observeEventType(.ChildChanged, withBlock: { snapshot in
            println("Someone has joined a room.")
            if snapshot.key == convoKey
            {
                println("Someone has joined MY chat room. Numer of people in room: \(snapshot.value)")
                self.joinConvo()
            }
            
        })
    }
    
    var userName = "Red"
    
    func addToExistingConvo(convoID: String)
    {
        println("Adding to existing convo...")
        let convoIDRef = IDListRef.childByAppendingPath(convoID)
        convoIDRef.setValue(2 as Int)
        chatRef = allChatsRef.childByAppendingPath(convoID)
        chatRef!.setValue("added to existing convo.")
        userName = "Blue"
        joinConvo()
    }
    
    func joinConvo()
    {
        if chatRef != nil
        {
            playAlert()
            chatRef!.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
                if let nameStr = snapshot.value.objectForKey("name") as? String
                {
                    if let textStr = snapshot.value.objectForKey("text") as? String
                    {
                        self.chat.append(["name": nameStr, "text": textStr])
                        self.tableView.reloadData()
                        
                        //self.scrolToBottom()
                        let delay = 0.15 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        
                        dispatch_after(time, dispatch_get_main_queue(), {
                            self.scrolToBottom()
                        })
                    }
                }
            })
            
            IDListRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
                println("Someone has left a room.")
                if snapshot.key == self.chatRef!.key
                {
                    println("The other person has left the room.")
                    self.statusLabel.text = "Status: The other person has left the room."
                    self.textField.enabled = false
                    self.sendButton.enabled = false
                }
                
            })
            
            println("Joined chat")
            statusLabel.text = "Status: In chat."
            if userName == "Red"
            {
                colorLabel.backgroundColor = redColor
            }
            else
            {
                colorLabel.backgroundColor = blueColor
            }
            textField.enabled = true
            sendButton.enabled = true
        }
        else
        {
            println("Error: Chat Room Reference is nil. Unable to join")
        }
    }
    
    func addMessage(textStr: String)
    {
        if chatRef != nil
        {
            chatRef!.childByAutoId().setValue(["name": userName, "text": textStr])
        }
    }
    
    //MARK: ------------- Set up messaging function ---------------------------------
    @IBAction func sendMessage(sender: UIButton) {
        let textContent = textField.text
        if textContent !=  ""
        {
            addMessage(textContent)
            textField.text = ""
        }
        
    }
    
    
    @IBAction func mingleButtonPressed(sender: UIButton) {
        let message = browseConvo()
        if message == "no key found"
        {
            println("Error while browsing for convo list.")
        }
        else if message == "too few users"
        {
            println("There are too few users. You will create your own chat room.")
            addNewConvo()
        }
        else
        {
            addToExistingConvo(message)
        }
        mingleButton.enabled = false
        leaveButton.enabled = true
        
    }
    
    
    @IBAction func leaveButtonPressed(sender: UIButton) {
        println("leaving room....")
        resetAll()
        statusLabel.text = "Status: Chat left."
    }
    
    override func didReceiveMemoryWarning() {
        println("app memory warning...")
        resetAll()
    }
    
    
    
    //MARK: ---------------- Set up tableView layout ----------------------------------
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: BasicCell = self.tableView.dequeueReusableCellWithIdentifier("BasicCell") as! BasicCell
        if let nameStr = chat[indexPath.row]["name"]
        {
            if let textStr = chat[indexPath.row]["text"]
            {
                cell.titleLabel.text = nameStr + ": " + textStr
                if nameStr == "Red"
                {
                    cell.titleLabel.textColor = redColor
                }
                else
                {
                    cell.titleLabel.textColor = blueColor
                }
            }
        }
        
        return cell
    }
    
    func scrolToBottom()
    {
        if (tableView.contentSize.height > tableView.frame.size.height)
        {
            let offset:CGPoint = CGPointMake(0, tableView.contentSize.height - tableView.frame.size.height)
            
            tableView.setContentOffset(offset, animated: true)
        }
    }
    
    
    //MARK:  --------- View color change etc... ---------------------------------
    let neutralColor = UIColor(white: 1.0, alpha: 1.0)
    let redColor = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
    let blueColor = UIColor(red: 0.1, green: 0.1, blue: 0.8, alpha: 1.0)
    
    func resetAll()
    {
        IDListRef.removeAllObservers()
        if chatRef != nil
        {
            chatRef!.removeAllObservers()
            let convoID = chatRef!.key
            let convoIDRef = IDListRef.childByAppendingPath(convoID)
            convoIDRef!.removeValue()
            
            //If the conversation is empty then remove it
            if chat.count == 0
            {
                chatRef!.removeValue()
            }
        }
        
        chatRef = nil //BE VERY CAREFUL HERE
        
        userName = "Red"
        chat = [Dictionary <String, String>]()
        tableView.reloadData()
        
        colorLabel.backgroundColor = neutralColor
        mingleButton.enabled = true
        textField.enabled = false
        leaveButton.enabled = false
        sendButton.enabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        resetAll()
    }
    
    //MARK: ------------------ Hide Keyboard -------------------------------------
    func dismissKeyboard(sender: AnyObject)
    {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    
    //MARK: -------- Keyboard handling and moving views ------------------------------
    func keyboardNotification(notification: NSNotification)
    {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            println("adjusting frame...")
            self.bottomContraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        var info = notification.userInfo!
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            
            println("adjusting frame down ...")
            self.bottomContraint.constant = 20
        })
    }
    
    //MARK: ---------- User Agreement ---------------
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    func setupUserAgreement()
    {
        let userAgreement1 = "The Mingle function aims to provide a virtual platform for community building between Bates students. When you Mingle, you will be randomly connected with another Batesie who is also seeking to Mingle at the same time. A completely anonymous virtual chat will be established between the two of you."
        chat.append(["name": "Bates Tech Club", "text": userAgreement1])
        let userAgreement2 = "Talk about classes, talk about life, talk about anything. Meet up for dinner, share your experiences, make new friends. But once you leave the chat, the connection is terminated, not to be reestablished again, unless fate brings the two of you together again."
        chat.append(["name": "-", "text": userAgreement2])
        let userAgreement3 = "By clicking ‘I agree’, you agree to be responsible for everything you say or exchange on this platform. Please be mindful and considerate when chatting. Share personal information at your own risk. At some point, you may also be required to verify your Bates email."
        chat.append(["name": "-", "text": userAgreement3])
        chat.append(["name": "-", "text": "Go forth and Mingle!"])
        tableView.reloadData()
        mingleButton.hidden = true
        leaveButton.hidden = true
    }
    
    @IBAction func userAgreedPressed(sender: UIButton) {
        defaults.setInteger(1, forKey: "userHasAgreed")
        IAgreeButton.hidden = true
        mingleButton.hidden = false
        leaveButton.hidden = false
        resetAll()
    }
    
    //MARK: UI variable declaration
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mingleButton: UIButton!
    @IBOutlet weak var leaveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var IAgreeButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var colorLabel: UILabel!
}