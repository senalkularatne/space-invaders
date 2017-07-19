// Team: Senal, Benjamin, Amen

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var skView : SKView!
    var highScore : Int = 0
    
    @IBOutlet weak var imgTitle: UIImageView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skView = view as SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        
        showStartMenu()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func startClicked(sender: AnyObject) {
        imgTitle.hidden = true
        btnStart.hidden = true
        btnStart.enabled = false
        
        let scene = GameScene(size: view.bounds.size)
        scene.controller = self
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    func showStartMenu(){
        imgTitle.hidden = false
        btnStart.hidden = false
        btnStart.enabled = true
        self.lblScore.text = "000000"
        
        let scene = StartScene(size: view.bounds.size)
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        
    }
}
