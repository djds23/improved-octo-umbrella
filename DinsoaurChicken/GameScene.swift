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
    private var dino : SKSpriteNode?

    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.chicken = self.childNode(withName: "chicken") as? SKSpriteNode
        self.chicken?.size = CGSize(width: 100, height: 100)
        self.dino = self.childNode(withName: "dino") as? SKSpriteNode
        self.dino?.xScale = -1


        let dinoSequence = SKAction.sequence([
            SKAction.moveTo(x: self.frame.minX, duration: 3),
            SKAction.hide(),
            SKAction.moveTo(x: self.frame.maxX, duration: 0),
            SKAction.unhide()
        ])
        let dinoLoop = SKAction.repeatForever(dinoSequence)
        dino?.run(dinoLoop)
        self.floor = self.childNode(withName: "floor") as? SKSpriteNode

//        self.chicken?.position = .zero
        if let floor = self.floor {
            floor.physicsBody = SKPhysicsBody(
                rectangleOf: floor.frame.size
            )
            floor.physicsBody?.isDynamic = false
            floor.physicsBody?.categoryBitMask = Masks.floor
        }

        if let chicken = self.chicken {
            chicken.physicsBody = SKPhysicsBody(
                rectangleOf: chicken.frame.size
            )
            chicken.physicsBody?.categoryBitMask = Masks.chicken
            chicken.physicsBody?.collisionBitMask = Masks.floor | Masks.dino
        }

        if let dino = self.dino {
            dino.physicsBody = SKPhysicsBody(
                rectangleOf: dino.frame.size
            )
            dino.physicsBody?.categoryBitMask = Masks.chicken
            dino.physicsBody?.collisionBitMask = Masks.floor | Masks.chicken
        }

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = Masks.floor
    }

    override func didMove(to view: SKView) {
        view.showsPhysics = true
    }

    func touchUp(atPoint pos : CGPoint) {
        self.chicken?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
