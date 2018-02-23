//
//  ArkitGameViewController.swift
//  ChupitApp
//
//  Created by Alessandro Minopoli on 15/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit
import ARKit
import CoreGraphics

class ArkitGameViewController: UIViewController, GameInteractionProtocol {
    
    
    @IBOutlet weak var arscnView: ARSCNView!
    var scnScene: SCNScene!
    let game = GameUtils.shared
    var par: GameViewController!
    var planeNodes: [SCNNode] = []
    var cardBoxNode: SCNNode!
    var cardNode: SCNNode!
    var deck = Singleton.shared.deck
    var ARBoxNode: SCNNode!
    weak var delegate: ChildToParentProtocol?
    
    lazy var drawnCards: Int = 0
    
    lazy var cardBoxNodeFullScale: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        configureLighting()
        game.mode = .ARKit
        // Set the view's delegate
        par = parent as! GameViewController
        par.interactionDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if cardBoxNode == nil {
            delegate?.hideChoices!(hide: true)
        }
         delegate?.showTrackingLabel!(hide: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        arscnView.session.run(configuration)
    }
    
    func setupScene() {
        arscnView.delegate = self
        
        // Show statistics such as fps and timing information
        arscnView.showsStatistics = false
        
        // Create a new scene
        scnScene = SCNScene()
        
        // Set the scene to the view
        arscnView.scene = scnScene
        
        game.state = .initializing
        
        addARCube()
    }
    
    func addARCube() {
        print("adding cube")
        let boxGeometry = SCNBox(width: 0.15, height: 0.15, length: 0.15, chamferRadius: 0)
        ARBoxNode = SCNNode(geometry: boxGeometry)
        boxGeometry.materials.first?.diffuse.contents = "ChupitApp.scnassets/CubeARDiffuse.png"
        ARBoxNode.position = SCNVector3Make(-0.5, 0.65, -2)
        arscnView.pointOfView?.addChildNode(ARBoxNode)
        ARBoxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 360, z: 0, duration: 360)))
        ARBoxNode.name = "ARCube"
    }
    
    func configureLighting() {
        arscnView.autoenablesDefaultLighting = true
        arscnView.automaticallyUpdatesLighting = true
    }
    
    func choiceButton(color: Int) {
        
//        ARBoxNode.removeFromParentNode()
        
        print("arkit hello")
        //        showCard(card: deck.cards[0], color: color)
        showCard(card: deck.randomCardFromDeck(), color: color)
        drawnCards += 1
        reduceDeckDimension(byValue: 1.0)
    }
    
    func newPlayer() {
        
    }
    
    func leaveTable() {
        
    }
    
    func endGame() {
        game.state = .gameOver
    }
    
    func setMaterials(identifier: String) {
        cardNode.geometry?.materials[5].diffuse.contents = "ChupitApp.scnassets/cards_textures/\(identifier).png"
    }
    
    func reduceDeckDimension(byValue: Float) {
        
        if deck.numberOfCardsRemaining() <= 0 {
            cardBoxNode.removeFromParentNode()
            game.state = .gameOver
        } else {
            cardBoxNode.scale.y -= (cardBoxNodeFullScale/52.0 * 0.5)*byValue
            print("cardsDrawn: \(drawnCards)")
        }
    }
    
    func showCard(card: Card, color: Int) {
        cardNode = SCNScene(named: "ChupitApp.scnassets/card_final.scn")?.rootNode.childNode(withName: "card", recursively: true)!
        setMaterials(identifier: card.identifier)
        cardNode.position = cardBoxNode.position
        scaleNodeForARKit(cardNode)
        let cameraEulers = arscnView.session.currentFrame!.camera.eulerAngles
        cardNode.position.y = cardBoxNode.position.y + 0.05
        cardNode.isHidden = true
        
        let rotationMatrix = SCNMatrix4MakeRotation(cameraEulers.y, 0, 1, 0)
        cardNode.transform = SCNMatrix4Mult(rotationMatrix, cardNode.transform)
        
        self.scnScene.rootNode.addChildNode(self.cardNode)
        delegate?.hideChoices!(hide: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.cardNode.isHidden = false
            moveUpAndRotateCard(self.cardNode, cameraEulers, nil, onFinished: { (finished) in
                //                DispatchQueue.main.async {
                ////                    self.delegate?.hideChoices!(hide: false)
                //                    if (color == 0 && card.color == "red") || (color == 1 && card.color == "black") {
                //                        self.delegate?.winPick!(win: true)
                //                        //some win animation
                //                    } else {
                //                        self.delegate?.winPick!(win: false)
                //                        //some lose animation
                //                    }
                //                    if self.game.state == .gameOver {
                //                        self.delegate?.goToReportController!()
                //                    }
                //                }
                //            })
                DispatchQueue.main.async {
                    if (color == 0 && card.color == "red") || (color == 1 && card.color == "black") {
                        //some win animation stuffs
                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                            if self.game.spawnedBaloons >= 11 {
                                timer.invalidate()
                                self.game.spawnedBaloons = 0
                            }
                            winAnimation(self.scnScene,self.arscnView.pointOfView!, onFinished: { (finished) in
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
                }
            })
        })
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        arscnView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: arscnView)
        let firstHitTest = arscnView.hitTest(location, options: nil)
        if firstHitTest.first?.node.name == "ARCube" {
            delegate?.switchController!(type: "SCN")
        } else {
            guard game.state == .initializing else { return }
            let hitTest = arscnView.hitTest(location, types: .existingPlaneUsingExtent)
            if let hitResult = hitTest.first {
                let translation = hitResult.worldTransform.columns.3
                let xTranslation = translation.x
                let yTranslation = translation.y
                let zTranslation = translation.z
                cardBoxNode = SCNScene(named: "ChupitApp.scnassets/Game.scn")!.rootNode.childNode(withName: "deck_full", recursively: true)!
                cardBoxNode.position = SCNVector3Make(xTranslation, yTranslation, zTranslation)
                scaleNodeForARKit(cardBoxNode)
                cardBoxNodeFullScale = cardBoxNode.scale.y * 0.5
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                    self.reduceDeckDimension(byValue: Float(52 - self.deck.numberOfCardsRemaining()))
                })
                print("remaining cards: ", deck.numberOfCardsRemaining())
                print("fullscale: ", cardBoxNodeFullScale)
                cardBoxNode.eulerAngles = arscnView.pointOfView!.eulerAngles
                cardBoxNode.eulerAngles.x = 0
                scnScene.rootNode.addChildNode(cardBoxNode)
                delegate?.hideChoices!(hide: false)
                game.state = .playing
                for node in planeNodes {
                    node.removeFromParentNode()
                }
            }
        }
    }
    
}

extension ArkitGameViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor, game.state == .initializing else {
            return
        }
        
        let planeWidth = CGFloat(planeAnchor.extent.x)
        let planeHeight = CGFloat(planeAnchor.extent.z)
        let planeGeometry = SCNPlane(width: planeWidth, height: planeHeight)
        
        planeGeometry.materials.first?.diffuse.contents = UIColor.cyan
        
        let planeNode = SCNNode(geometry: planeGeometry)
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        planeNode.eulerAngles.x = -.pi/2
        planeNodes.append(planeNode)
        print("found")
        node.addChildNode(planeNode)
        
        DispatchQueue.main.async {
            self.delegate?.showTrackingLabel!(hide: true)
        }
        
    }
    //
    //    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    //        if chosenAnchorPlaneIdentifier != nil && anchor.identifier == chosenAnchorPlaneIdentifier {
    //          return cardBoxNode
    //        } else {
    //            let node = SCNNode()
    //            return node
    //    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
}



