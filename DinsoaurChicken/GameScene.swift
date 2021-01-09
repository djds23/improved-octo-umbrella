//
//  GameScene.swift
//  DinsoaurChicken
//
//  Created by Dean Silfen on 1/8/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var chicken: SKSpriteNode?
    private var label : SKLabelNode?

    override func didMove(to view: SKView) {
        self.chicken = SKSpriteNode(imageNamed: "chicken-drawing")
        self.chicken?.size = CGSize(width: 100, height: 100)
        if let chicken = chicken {
            self.addChild(chicken)
        }
        self.chicken?.position = CGPoint(
            x: self.frame.midX,
            y: self.frame.midY
        )
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        self.chicken?.position = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        self.chicken?.position = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.chicken?.position = pos
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
