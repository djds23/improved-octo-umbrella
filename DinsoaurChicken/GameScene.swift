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
    private var floor: SKSpriteNode?
    private var dino: SKSpriteNode?
    private var scoreLabel: SKLabelNode?
    private var enemyEntity: EnemyEntity!

    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.chicken = self.childNode(withName: "chicken") as? SKSpriteNode
        self.dino = self.childNode(withName: "dino") as? SKSpriteNode
        self.floor = self.childNode(withName: "floor") as? SKSpriteNode
        self.scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode

        var floorHeight = CGFloat(0)
        if let floor = self.floor {
            floor.physicsBody = SKPhysicsBody(
                rectangleOf: floor.frame.size
            )
            floor.physicsBody?.isDynamic = false
            floor.physicsBody?.categoryBitMask = Masks.floor
            floorHeight = floor.frame.maxY
        }

        if let chicken = self.chicken {
            chicken.physicsBody = SKPhysicsBody(
                rectangleOf: chicken.frame.size
            )
            chicken.physicsBody?.categoryBitMask = Masks.chicken
            chicken.physicsBody?.collisionBitMask = Masks.floor | Masks.dino
        }

        var dinoHalfWidth = CGFloat(0)
        var dinoHalfHeight = CGFloat(0)
        if let dino = self.dino {
            dino.physicsBody = SKPhysicsBody(
                rectangleOf: dino.frame.size
            )
            dino.physicsBody?.categoryBitMask = Masks.chicken
            dino.physicsBody?.collisionBitMask = Masks.floor | Masks.chicken
            dino.physicsBody?.contactTestBitMask = Masks.chicken
            dinoHalfHeight = dino.size.height / 2
            dinoHalfWidth = dino.size.width / 2
        }

        let dinoSequence = SKAction.sequence([
            SKAction.customAction(withDuration: 0, actionBlock: { [weak self ](_, _) in
                self?.enemyEntity?.stateMachine.enter(RunningState.self)
            }),
            SKAction.moveTo(x: self.frame.minX - 500, duration: 2),
            SKAction.hide(),
            SKAction.moveTo(x: self.frame.maxX, duration: 0),
            SKAction.move(
                to: CGPoint(
                    x: self.frame.maxX + dinoHalfWidth,
                    y: floorHeight + dinoHalfHeight
                ),
                duration: 0
            ),
            SKAction.rotate(toAngle: 0, duration: 0),
            SKAction.customAction(withDuration: 0, actionBlock: { [weak self ](_, _) in
                self?.enemyEntity?.stateMachine.enter(RunningState.self)
            }),
            SKAction.unhide()
        ])

        let dinoLoop = SKAction.repeatForever(dinoSequence)
        dinoLoop.timingMode = .linear
        dino?.run(dinoLoop)
        enemyEntity = configureEnemyEntity()

        self.physicsWorld.contactDelegate = self
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
    
    var previousUpdateTime: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        let delta = currentTime - previousUpdateTime
        enemyEntity.update(deltaTime: delta)

        if let dino = self.dino, intersects(dino) == false {
            enemyEntity?.stateMachine.enter(OffscreenState.self)
        }
        scoreLabel?.text = "Score: \(enemyEntity.score)"
    }

    func configureEnemyEntity() -> EnemyEntity {
        guard let dino = self.dino else {
            fatalError("Cannot configure before enemy is set")
        }
        let entity = EnemyEntity()
        dino.entity = entity
        entity.sprite = dino
        return entity
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "dino" || contact.bodyB.node?.name == "dino" {
            enemyEntity?.stateMachine.enter(IntersectingState.self)
        }
    }
}
