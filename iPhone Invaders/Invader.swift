// Team: Senal, Benjamin, Amen

import UIKit
import SpriteKit

class Invader: SKSpriteNode {
    
    var invaderRow = 0
    var invaderColumn = 0
    let INVADER_SCALE : CGFloat = 0.125
    
    override init() {
        let texture = SKTexture(imageNamed: "Alien6")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.setScale(INVADER_SCALE)

        self.name = "invader"
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.frame.size)
        self.physicsBody?.dynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ship
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func fireBullet(scene: SKScene){
        
    }
    
}
