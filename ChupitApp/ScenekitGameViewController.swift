//
//  ScenekitGameViewController.swift
//  ChupitApp
//
//  Created by Alessandro Minopoli on 15/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class ScenekitGameViewController: UIViewController, GameInteractionProtocol {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var par: GameViewController!
    var cardBoxNode: SCNNode!
    var cardNode: SCNNode!
    var cameraNode: SCNNode!
    let game = GameUtils.shared
    var deck = Singleton.shared.deck
    weak var delegate: ChildToParentProtocol?
    var drawnCards: Int = 0
    var cubeRotating: SCNNode!
    
    var presentingScene: Bool = true
    
    
    lazy var cardBoxNodeFullScale: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        setupNodes()
        game.mode = .SceneKit
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        par = parent as! GameViewController
        par.interactionDelegate = self
        if presentingScene {
            delegate?.hideChoices!(hide: true)
        }
        delegate?.showTrackingLabel!(hide: true)
//        if game.state == .initializing {
//            delegate?.hideChoices!(hide: true)
//        }
    }
    
    func setupScene() {
        scnView = SCNView(frame: self.view.frame)
        self.view.addSubview(scnView)
        scnScene = SCNScene(named: "ChupitApp.scnassets/Game.scn")
        scnView.scene = scnScene
        scnView.allowsCameraControl = false
        scnView.antialiasingMode = .multisampling4X
        game.state = .initializing
    }
    
    func setupNodes() {
        cardBoxNode = scnScene.rootNode.childNode(withName: "deck_full_reference", recursively: true)!
        cameraNode = scnScene.rootNode.childNode(withName: "camera", recursively: true)!
        cardBoxNodeFullScale = cardBoxNode.scale.y
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                self.reduceDeckDimension(byValue: Float(52 - self.deck.numberOfCardsRemaining()))
            })
        cubeRotating = scnScene.rootNode.childNode(withName: "cube", recursively: true)!
        cubeRotating.geometry?.materials.first?.diffuse.contents = "ChupitApp.scnassets/Cube3DDiffuse.png"
        cubeRotating.name = "SCNCube"
        cameraNode.runAction(SCNAction.moveBy(x: 0, y: -7, z: -10, duration: 4) , completionHandler: {
            DispatchQueue.main.async {
                self.delegate?.hideChoices!(hide: false)
                self.presentingScene = false
            }
        })
       
    }
    
    func showCard(card: Card, color: Int) {
        cardNode = SCNScene(named: "ChupitApp.scnassets/card_final.scn")?.rootNode.childNode(withName: "card", recursively: true)!
        cardNode.position = cardBoxNode.position
        setMaterials(identifier: card.identifier)
        cardNode.position.y = cardBoxNode.position.y + 0.3
        scnScene.rootNode.addChildNode(cardNode)
        delegate?.hideChoices!(hide: true)
        moveUpAndRotateCard(cardNode, nil, cameraNode, onFinished: { (finished) in
            DispatchQueue.main.async {
                if (color == 0 && card.color == "red") || (color == 1 && card.color == "black") {
                    //some win animation stuffs
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                        if self.game.spawnedBaloons >= 11 {
                            timer.invalidate()
                            self.game.spawnedBaloons = 0
                        }
                        winAnimation(self.scnScene,nil, onFinished: { (finished) in
                            DispatchQueue.main.async {
                                self.delegate?.winPick!(win: true)
                                self.delegate?.hideChoices!(hide: false)
                            }
                        })
                    })
                } else {
                    //some lose animation stuffs
                    self.delegate?.winPick!(win: false)
                    self.delegate?.hideChoices!(hide: false)
                }
                if self.game.state == .gameOver {
                    self.delegate?.goToReportController!()
                }
            }
            
        })
    }
    
    func reduceDeckDimension(byValue: Float) {
        
        if deck.numberOfCardsRemaining() <= 0 {
            cardBoxNode.removeFromParentNode()
            game.state = .gameOver
        } else {
            cardBoxNode.scale.y -= (cardBoxNodeFullScale/52.0)*byValue
            print("cardsDrawn: ", drawnCards)
        }
    }
    
    func choiceButton(color: Int) {
        
        if game.state == .initializing {
            game.state = .playing
//            cubeRotating.removeFromParentNode()
        }
        
        drawnCards += 1
        showCard(card: deck.randomCardFromDeck(), color: color)
//        showCard(card: deck.cards[0], color: color)
        reduceDeckDimension(byValue: 1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: scnView)
        let hitTest = scnView.hitTest(location, options: nil)
        if let result = hitTest.first {
            if result.node.name == "SCNCube" {
                delegate?.switchController!(type: "AR")
            }
        }
    }
    
    func newPlayer() {
        
    }
    
    func leaveTable() {
        
    }
    
    func endGame() {
        game.state = .gameOver
    }
    
    func setMaterials(identifier: String) {
        cardNode.geometry?.materials[5].lightingModel = .constant
        cardNode.geometry?.materials[5].diffuse.contents = "ChupitApp.scnassets/cards_textures/\(identifier).png"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
//    func winAnimation() {
//        let node = winNode()
//        scnScene.rootNode.addChildNode(node)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
