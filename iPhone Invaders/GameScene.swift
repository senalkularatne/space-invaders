// Team: Senal, Benjamin, Amen

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Bullet : UInt32 = 0b1
    static let Ship : UInt32 = 0b10
    static let Enemy : UInt32 = 0b100
    static let EnemyBullet : UInt32 = 0b1000
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Create player sprite
    let player = SKSpriteNode(imageNamed: "PlayerShip1.png")
    let SPEED = 10
    let SHOOT_DELAY = 0.5
    let MOVE_DELAY = 1.0 / 30.0 //Once per frame
    let PLAYER_SCALE = CGFloat(0.25)
    let BULLET_SCALE = CGFloat(0.1)
    
    let rowsOfInvaders = 4
    var invaderSpeed = 4
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    var invaderNum = 1
    
    //Variable to track where the user is touching
    var touchPosition = CGPoint()
    
    weak var controller : GameViewController?
    
    var score = 0
    
    override func didMoveToView(view: SKView) {
        
        //Create collision detection
        physicsWorld.gravity = CGVectorMake(0,0)
        physicsWorld.contactDelegate = self
        
        //Accept touch events
        self.userInteractionEnabled = true
        
        backgroundColor = SKColor.blackColor()
        var backgroundImage = SKSpriteNode(imageNamed: "Background2.jpg")
        backgroundImage.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(backgroundImage)
        
        setupInvaders()
        setupPlayer()
        
        score = 0
        controller?.lblScore.text = "000000"
    }
    
    func setupPlayer(){
        // Set position: Centered horizontally, at bottom.
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        //Scale down to a reasonable size.
        player.setScale(PLAYER_SCALE)
        //Set touch position at player so they don't move initially.
        touchPosition = player.position
        // Add player to scene
        addChild(player)
        
        //Add movement behavior to the player
        player.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({ self.moveToTouch() }),
            SKAction.waitForDuration(MOVE_DELAY)
            ])))
        
        //Add shooting behavior
        player.runAction(SKAction.repeatActionForever(SKAction.sequence([
            SKAction.runBlock({ self.shoot() }),
            SKAction.waitForDuration(SHOOT_DELAY)
            ])))
        
        //Player collision detection
        //Player interacts only with Enemy objects
        //Shrink the hitbox just a little so that they don't get hit on the whitespace of their sprite.
        let hitbox: CGRect = player.frame.rectByInsetting(dx: 10, dy: 10)
        player.physicsBody = SKPhysicsBody(rectangleOfSize: hitbox.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.Ship
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.EnemyBullet
        player.physicsBody?.collisionBitMask = PhysicsCategory.None
        player.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    func setupInvaders(){
        rightBounds = self.size.width - 30
        
        var invaderRow = 0
        var invaderColumn = 0
        let numberOfInvaders = invaderNum * 2 + 1
        for var i = 1; i <= rowsOfInvaders; i++ {
            invaderRow = i
            for var j = 1; j <= numberOfInvaders; j++ {
                invaderColumn = j
                let tempInvader:Invader = Invader()
                let invaderHalfWidth:CGFloat = tempInvader.size.width/2
                
                //xPositionStart used to allign invaders at the middle
                let xPositionStart:CGFloat = size.width/2
                //goes up there after 2 - invaderHalfWidth - (CGFloat(invaderNum) * tempInvader.size.width) + CGFloat(10)//10 is spacing
                
                tempInvader.position = CGPoint(x:xPositionStart + ((tempInvader.size.width+CGFloat(10))*(CGFloat(j-1))), y:CGFloat(self.size.height - CGFloat(i) * 60))
                // 150 determines the spaces
                
                tempInvader.invaderRow = invaderRow
                tempInvader.invaderColumn = invaderColumn
                addChild(tempInvader)
            }
        }
    } // End setupInvaders
    
    override func update(currentTime: CFTimeInterval) {
        // Called before each frame is rendered
        moveInvaders()
    }
    
    func moveInvaders(){
        // this method searches the node’s children and calls the closure once for each matching node it finds with the matching name "invader".
        enumerateChildNodesWithName("invader") { node, stop in
            let invader = node as SKSpriteNode
            let invaderHalfWidth = invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)
            if(invader.position.x > self.rightBounds - invaderHalfWidth || invader.position.x < self.leftBounds + invaderHalfWidth){
                self.invaderSpeed *= -1
                self.enumerateChildNodesWithName("invader") { node, stop in
                    let invader = node as SKSpriteNode
                    if invader.position.y > 40{
                        invader.position.y -= CGFloat(20)
                    }
                }
            }
        }
    } // End moveInvaders
    
    func moveToTouch(){
        //Prevent jittering when at destination
        let distance = sqrt(pow(touchPosition.x  - player.position.x,2) + pow(touchPosition.y  - player.position.y,2))
        if(Int(distance) < SPEED){
            player.position = touchPosition
        }
        else{
            //Get angle to target
            let angle:CGFloat = atan2(touchPosition.y - player.position.y, touchPosition.x - player.position.x)
            //Calculate amount to move on each axis.
            let dx = cos(angle) * CGFloat(SPEED)
            let dy = sin(angle) * CGFloat(SPEED)
            //Move the player
            player.position.x += dx
            player.position.y += dy
        }
    }
    
    func shoot(){
        //Create bullet
        let bullet = SKSpriteNode(imageNamed: "PlayerShipBullet1.png")
        bullet.position.x = player.position.x
        bullet.position.y = player.position.y + player.frame.height / 2 //Spawn in front of player.
        bullet.setScale(BULLET_SCALE)
        
        //Bullet goes straight up to top of screen
        let destination = CGPoint(x: player.position.x, y: self.frame.height + 100)
        
        //Bullet collision detection
        //Bullet interacts only with Enemy objects
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.frame.size)
        bullet.physicsBody?.dynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        //Add to scene
        addChild(bullet)
        //Start moving
        bullet.runAction(SKAction.sequence([
            SKAction.moveTo(destination, duration: 1.0),
            SKAction.removeFromParent()
        ]))
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Sort the bodies by type to make tests easier later.
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.node == nil || secondBody.node == nil){
            return
        }
        
        /*println("Collision")
        println(firstBody)
        println(firstBody.node)
        println(secondBody)
        println(secondBody.node)*/
        
        // Bullet collides with Enemy
        if ((firstBody.categoryBitMask & PhysicsCategory.Bullet != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0)) {
                shotEnemy(firstBody.node as SKSpriteNode, enemy: secondBody.node as SKSpriteNode)
        }
        
        // EnemyBullet collides with Ship
        if ((firstBody.categoryBitMask & PhysicsCategory.Ship != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.EnemyBullet != 0)) {
                enemyHitPlayer(firstBody.node as SKSpriteNode, enemyBullet: secondBody.node as SKSpriteNode)
        }
        
        // Enemy collides with Ship
        if ((firstBody.categoryBitMask & PhysicsCategory.Ship != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Enemy != 0)) {
                enemyHitPlayer(firstBody.node as SKSpriteNode, enemyBullet: secondBody.node as SKSpriteNode)
        }
        
    }
    
    func padLeft(var string : String, length: Int) -> String{
        while(countElements(string) < length){
            string = "0" + string
        }
        return string
    }
    
    func shotEnemy(bullet : SKSpriteNode, enemy : SKSpriteNode){
        score += 100
        let scorestring:String = String(score)
        controller?.lblScore.text = padLeft(scorestring, length: 6)
        if(score > controller?.highScore){
            controller?.highScore = score
            let scorestring:String = String(score)
            controller?.lblHigh.text = padLeft(scorestring, length: 6)
        }
        
        enemy.removeFromParent()
        bullet.removeFromParent()
    }
    
    func enemyHitPlayer(player: SKSpriteNode, enemyBullet: SKSpriteNode){
        println("Game Over!")
        //Game over!
        player.removeFromParent()
        enemyBullet.removeFromParent()
        
        //Go to game over screen.
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        let gameOverScene = GameOverScene(size: self.size, controller: controller!)
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
    //If the player touches or moves their finger, move the ship to that spot
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch
        self.touchPosition = touch.locationInNode(self)
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch:UITouch = touches.anyObject() as UITouch
        self.touchPosition = touch.locationInNode(self)
    }
    
}
