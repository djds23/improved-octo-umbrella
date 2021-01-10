//
//  EnemyEntity.swift
//  DinsoaurChicken
//
//  Created by Dean Silfen on 1/10/21.
//

import GameplayKit


class RunningState: GKState {
}

class IntersectingState: GKState {
    var score = 0
    override func didEnter(from previousState: GKState?) {
        if previousState is RunningState {
            score += 1
        }
    }
}

class EnemyEntity: GKEntity {
    weak var sprite: SKSpriteNode? = nil
    let stateMachine = GKStateMachine(
        states: [
            RunningState(),
            IntersectingState()
        ]
    )

    var score: Int {
        guard let intersectingState = stateMachine
                .state(forClass: IntersectingState.self) else {
            fatalError("Improperaly configured state machine")
        }
        return intersectingState.score
    }
    override func update(deltaTime seconds: TimeInterval) {
        stateMachine.update(deltaTime: seconds)
        if stateMachine.currentState == nil {
            stateMachine.enter(RunningState.self)
        }
    }
}
