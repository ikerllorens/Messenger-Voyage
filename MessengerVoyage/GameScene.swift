//
//  GameScene.swift
//  MessengerVoyage
//
//  Created by Iker on 10/11/15.
//  Copyright (c) 2015 Scuigi Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var motor: GameMotor!
    override func didMoveToView(view: SKView) {
        self.motor = GameMotor()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}