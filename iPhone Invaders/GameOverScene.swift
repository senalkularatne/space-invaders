// Team: Senal, Benjamin, Amen

import Foundation
import SpriteKit

class GameOverScene : SKScene{
    
    weak var controller : GameViewController?
    
    init(size: CGSize, controller: GameViewController) {
        
        super.init(size: size)
        
        self.controller = controller
        
        backgroundColor = SKColor.blackColor()
        
        var message = "Game Over!"
        
        let label = SKLabelNode()
        label.text = message
        label.fontColor = SKColor.redColor()
        label.fontName = "HelveticaNeue-Bold"
        label.fontSize = 60
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        //Display the scene for a few seconds, then return to the title screen.
        self.runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock({ self.controller!.showStartMenu() })
            ]))
        
    }
    
    // Dummy implementation we need to have.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
