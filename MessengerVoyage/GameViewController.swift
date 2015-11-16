//
//  GameViewController.swift
//  MessengerVoyage
//
//  Created by Iker on 10/11/15.
//  Copyright (c) 2015 Scuigi Studios. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var motor: GameMotor!
    var initGame: Array<AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        self.motor = GameMotor(parameters: initGame)
        let gameScene = GameScene(fileNamed: "StartScreenScene")
        skView.presentScene(gameScene)
    }

//    override func shouldAutorotate() -> Bool {
//        return true
//    }

//    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
////        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
////            return .AllButUpsideDown
////        } else {
////            return .All
////        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
