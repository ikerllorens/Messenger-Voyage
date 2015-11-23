//
//  GameViewController.swift
//  MessengerVoyage
//
//  Created by Iker on 10/11/15.
//  Copyright (c) 2015 Scuigi Studios. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    var motor: GameMotor!
    var initGame: Array<AnyObject>!
    let userProfile = UserModel()
    var currentShownEvent: NSDictionary!
    
    @IBOutlet weak var progressView: UIProgressView!
    private var linkView: CADisplayLink!
    private var touchInit: NSDate!
    private var 🕧: NSTimer!
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTextField: UITextView!
    @IBOutlet weak var eventChoiceA: UIView!
    @IBOutlet weak var eventChoiceB: UIView!
    @IBOutlet weak var eventChoiceC: UIView!
    @IBOutlet weak var eventChoiceD: UIView!
    @IBOutlet weak var eventChoiceTextA: EventSelection!
    @IBOutlet weak var eventChoiceTextB: EventSelection!
    @IBOutlet weak var eventChoiceTextC: EventSelection!
    @IBOutlet weak var eventChoiceTextD: EventSelection!
    
    convenience init(){
        self.init()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventView.hidden = true
        initGame.append(userProfile)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventHappened:", name: "positiveEventOcurred", object: motor)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "eventHappened:", name: "negativeEventOcurred", object: motor)
        self.motor = GameMotor(parameters: initGame)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endGame:", name: "gameEnded", object: motor)
        self.motor = GameMotor(parameters: initGame)
        self.progressView.progress = 0
        🕧 = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.1), target: self, selector: Selector("updateProgress"), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func eventHappened(notification: NSNotification) {
        self.eventView.hidden = false
        let data = notification.userInfo as NSDictionary!
        dispatch_async(dispatch_get_main_queue(), {
            self.eventTitleLabel.text = data.objectForKey("Title") as? String
            self.eventTextField.text = data.objectForKey("Text") as? String
            self.currentShownEvent = data
            
            if let optionADict = data.objectForKey("OptionA") as? NSDictionary {
                self.eventChoiceA.hidden = false
                self.eventChoiceTextA.text = optionADict.objectForKey("Text") as! String
            } else {
                self.eventChoiceA.hidden = true
            }
            if let optionBDict = data.objectForKey("OptionB") as? NSDictionary {
                self.eventChoiceB.hidden = false
                self.eventChoiceTextB.text = optionBDict.objectForKey("Text") as! String
            } else {
                self.eventChoiceB.hidden = true
            }
            if let optionCDict = data.objectForKey("OptionC") as? NSDictionary {
                self.eventChoiceC.hidden = false
                self.eventChoiceTextC.text = optionCDict.objectForKey("Text") as! String
            } else {
                self.eventChoiceC.hidden = true
            }
            if let optionDDict = data.objectForKey("OptionD") as? NSDictionary {
                self.eventChoiceD.hidden = false
                self.eventChoiceTextD.text = optionDDict.objectForKey("Text") as! String
            } else {
                self.eventChoiceD.hidden = true
            }
        })
        
        
        // Ventana de evento
        //print(data)
    }
    
    @IBAction func selectDecission(sender: UILongPressGestureRecognizer) {
        
        if (sender.state == UIGestureRecognizerState.Began) {
            self.linkView = CADisplayLink(target: sender.view!, selector: "inflate")
            linkView.frameInterval = 1
            linkView.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        } else if (sender.state == UIGestureRecognizerState.Ended) {
            print("Ended")
            self.linkView.invalidate()
            (sender.view as! EventSelection).returnNormalState()
        } else if (sender.state == UIGestureRecognizerState.Cancelled) {
            self.linkView.invalidate()
            (sender.view as! EventSelection).returnNormalState()
        }
        if ((sender.view as! EventSelection).selectPercentage > 0.9){
            if (sender.view == self.eventChoiceTextA) {
                self.eventChoiceTextA.returnNormalState()
                self.eventChoiceTextB.returnNormalState()
                self.eventChoiceTextC.returnNormalState()
                self.eventChoiceTextD.returnNormalState()
                NSNotificationCenter.defaultCenter().postNotificationName("eventDecissionMade", object: self, userInfo: self.currentShownEvent.objectForKey("OptionA") as? [NSObject: AnyObject])
                self.eventView.hidden = true
            } else if (sender.view == self.eventChoiceTextB) {
                self.eventChoiceTextA.returnNormalState()
                self.eventChoiceTextB.returnNormalState()
                self.eventChoiceTextC.returnNormalState()
                self.eventChoiceTextD.returnNormalState()
                NSNotificationCenter.defaultCenter().postNotificationName("eventDecissionMade", object: self, userInfo: self.currentShownEvent.objectForKey("OptionB") as? [NSObject: AnyObject])
                self.eventView.hidden = true
            } else if (sender.view == self.eventChoiceTextC) {
                self.eventChoiceTextA.returnNormalState()
                self.eventChoiceTextB.returnNormalState()
                self.eventChoiceTextC.returnNormalState()
                self.eventChoiceTextD.returnNormalState()
                NSNotificationCenter.defaultCenter().postNotificationName("eventDecissionMade", object: self, userInfo: self.currentShownEvent.objectForKey("OptionC") as? [NSObject: AnyObject])
                self.eventView.hidden = true
            } else if (sender.view == self.eventChoiceTextD) {
                self.eventChoiceTextA.returnNormalState()
                self.eventChoiceTextB.returnNormalState()
                self.eventChoiceTextC.returnNormalState()
                self.eventChoiceTextD.returnNormalState()
                NSNotificationCenter.defaultCenter().postNotificationName("eventDecissionMade", object: self, userInfo: self.currentShownEvent.objectForKey("OptionD") as? [NSObject: AnyObject])
                self.eventView.hidden = true
            } else {
                (sender.view as! EventSelection).returnNormalState()
                print("Error")
            }
        }
    }
    
    func updateProgress() {
        self.progressView.progress = Float(self.motor.progressPercentage())
    }
    
    func endGame(notif: NSNotification) {
        let storyBoardName = "Main"
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("MissionEnded")
        self.presentViewController(vc, animated: true, completion: nil)
        self.🕧.invalidate()
    }
}