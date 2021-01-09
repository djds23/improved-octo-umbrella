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
    private var floor : SKSpriteNode?

    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.chicken = SKSpriteNode(imageNamed: "chicken-drawing")
        self.chicken?.size = CGSize(width: 100, height: 100)
        if let chicken = chicken {
            self.addChild(chicken)
        }
        self.chicken?.position = CGPoint(
            x: self.frame.midX,
            y: self.frame.midY
        )
        self.floor = self.childNode(withName: "floor") as? SKSpriteNode

        if let floor = self.floor {
            print("DEANDEBUG \(floor.frame.size)")
            floor.physicsBody = SKPhysicsBody(
                rectangleOf: floor.frame.size
            )
            floor.physicsBody?.isDynamic = false
            floor.physicsBody?.categoryBitMask = 1
        }

        if let chicken = self.chicken {
            chicken.physicsBody = SKPhysicsBody(
                rectangleOf: chicken.frame.size
            )
            chicken.physicsBody?.collisionBitMask = 1
        }

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }

    override func didMove(to view: SKView) {
        view.showsPhysics = true
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
