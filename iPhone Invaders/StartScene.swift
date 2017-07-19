// Team: Senal, Benjamin, Amen

import SpriteKit

class StartScene: SKScene {
    override func didMoveToView(view: SKView) {
        var backgroundImage = SKSpriteNode(imageNamed: "Background1.jpg")
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(backgroundImage)
        
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
