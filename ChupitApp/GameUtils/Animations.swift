//
//  Animations.swift
//  ChupitApp
//
//  Created by Alessandro Minopoli on 15/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

func scaleNodeForARKit(_ node: SCNNode) {
    node.runAction(.customAction(duration: 0, action: { node, _ in
        node.physicsBody = nil
        node.scale = SCNVector3(x: Float(node.scale.x * 0.5), y: Float(node.scale.y * 0.5), z: Float(node.scale.z * 0.5))
    }))
}

func winAnimation(_ scene: SCNScene, _ cameraNode: SCNNode? = nil, onFinished: @escaping (Bool) -> Void) {
    switch GameUtils.shared.mode {
        
    case .ARKit:
        let node = SCNScene(named: "ChupitApp.scnassets/balloon.dae")!.rootNode.childNode(withName: "Circle", recursively: true)!
        node.geometry?.materials.first?.diffuse.contents = UIColor.random()
        let randomX = Float.random(min: -0.7, max: 0.7)
        node.position = SCNVector3Make(randomX, -1.3, -2)
        node.name = "balloon"
        node.scale = SCNVector3Make(node.scale.x * 0.7, node.scale.y * 0.7, node.scale.z * 0.7)
        cameraNode!.addChildNode(node)
        GameUtils.shared.spawnedBaloons += 1
        node.runAction(SCNAction.sequence([
            SCNAction.moveBy(x: 0, y: 2, z: 0, duration: 2),
            SCNAction.removeFromParentNode()]), completionHandler: {
                
                let countNodes = cameraNode!.childNodes(passingTest:  { (node, stop) -> Bool in
                    if node.name == "balloon" {
                        return true
                    }
                    return false
                })
                
                if countNodes.count <= 0 {
                    print("Helloooooo")
                    onFinished(true)
                }
                
        })
        
    case .SceneKit:
        let node = SCNScene(named: "ChupitApp.scnassets/balloon.dae")!.rootNode.childNode(withName: "Circle", recursively: true)!
        node.geometry?.materials.first?.diffuse.contents = UIColor.random()
        let randomX = Float.random(min: -1, max: 1)
        node.position = SCNVector3Make(randomX, 1.0, -9)
        node.name = "balloon"
        scene.rootNode.addChildNode(node)
        GameUtils.shared.spawnedBaloons += 1
        node.runAction(SCNAction.sequence([
            SCNAction.moveBy(x: 0, y: 5, z: 0, duration: 2),
            SCNAction.removeFromParentNode()]), completionHandler: {
                
                let countNodes = scene.rootNode.childNodes(passingTest:  { (node, stop) -> Bool in
                    if node.name == "balloon" {
                        return true
                    }
                    return false
                })
                
                if countNodes.count <= 0 {
                    print("Helloooooo")
                    onFinished(true)
                }
                
        })
    }
    
}

func loseAnimation(_ scene: SCNScene, _ cameraNode: SCNNode? = nil, onFinished: @escaping (Bool) -> Void) {
    
    switch GameUtils.shared.mode {
        
    case .ARKit:
        
        let nodeOne = SCNScene(named: "ChupitApp.scnassets/chupito.scn")!.rootNode.childNode(withName: "bicchiere", recursively: true)!
        let fluidOne = nodeOne.childNode(withName: "liquido", recursively: true)!
        let nodeTwo = SCNScene(named: "ChupitApp.scnassets/chupito.scn")!.rootNode.childNode(withName: "bicchiere", recursively: true)!
        let fluidTwo = nodeTwo.childNode(withName: "liquido", recursively: true)!
        fluidTwo.geometry?.materials.first?.diffuse.contents = UIColor.random()
        fluidOne.geometry?.materials.first?.diffuse.contents = UIColor.random()
        nodeOne.position = SCNVector3Make(-0.2, 1, -1)
        nodeTwo.position = SCNVector3Make(0.2, 1, -1)
        nodeOne.scale = SCNVector3Make(nodeOne.scale.x * 0.5, nodeOne.scale.y*0.5, nodeOne.scale.z * 0.5)
        nodeTwo.scale = SCNVector3Make(nodeTwo.scale.x * 0.5, nodeTwo.scale.y*0.5, nodeTwo.scale.z * 0.5)
        cameraNode!.addChildNode(nodeOne)
        cameraNode!.addChildNode(nodeTwo)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
        moveDownAction.timingMode = .linear
        let waitAction = SCNAction.wait(duration: 0.5)
        let danceLeftAction = SCNAction.rotateBy(x: 0, y: 0, z: convertToRadians(angle: -45), duration: 0.25)
        let danceRightAction = SCNAction.rotateBy(x: 0, y: 0, z: convertToRadians(angle: 45), duration: 0.25)
        nodeOne.runAction(SCNAction.sequence([moveDownAction, waitAction, danceLeftAction, danceLeftAction.reversed(), danceRightAction, danceRightAction.reversed(), danceLeftAction, danceLeftAction.reversed(), danceRightAction, danceRightAction.reversed(), SCNAction.removeFromParentNode()]), completionHandler: {
            onFinished(true)
        })
        nodeTwo.runAction(SCNAction.sequence([moveDownAction, waitAction, danceRightAction, danceRightAction.reversed(), danceLeftAction, danceLeftAction.reversed(), danceRightAction, danceRightAction.reversed(), danceLeftAction, danceLeftAction.reversed(), SCNAction.removeFromParentNode()]))

        
    case .SceneKit:
        let nodeOne = SCNScene(named: "ChupitApp.scnassets/chupito.scn")!.rootNode.childNode(withName: "bicchiere", recursively: true)!
        let fluidOne = nodeOne.childNode(withName: "liquido", recursively: true)!
        let nodeTwo = SCNScene(named: "ChupitApp.scnassets/chupito.scn")!.rootNode.childNode(withName: "bicchiere", recursively: true)!
        let fluidTwo = nodeTwo.childNode(withName: "liquido", recursively: true)!
        fluidOne.geometry?.materials.first?.lightingModel = .constant
        fluidTwo.geometry?.materials.first?.lightingModel = .constant
        fluidTwo.geometry?.materials.first?.diffuse.contents = UIColor.random()
        fluidOne.geometry?.materials.first?.diffuse.contents = UIColor.random()
        nodeOne.position = SCNVector3Make(-0.55, 5, -9)
        nodeTwo.position = SCNVector3Make(0.55, 5, -9)
        scene.rootNode.addChildNode(nodeOne)
        scene.rootNode.addChildNode(nodeTwo)
        let moveDownAction = SCNAction.moveBy(x: 0, y: -2, z: 0, duration: 1)
        moveDownAction.timingMode = .linear
        let waitAction = SCNAction.wait(duration: 0.5)
        let danceLeftAction = SCNAction.rotateBy(x: 0, y: 0, z: convertToRadians(angle: -45), duration: 0.25)
        let danceRightAction = SCNAction.rotateBy(x: 0, y: 0, z: convertToRadians(angle: 45), duration: 0.25)
        nodeOne.runAction(SCNAction.sequence([moveDownAction, waitAction, danceLeftAction, danceLeftAction.reversed(), danceRightAction, danceRightAction.reversed(), danceLeftAction, danceLeftAction.reversed(), danceRightAction, danceRightAction.reversed(), SCNAction.removeFromParentNode()]), completionHandler: {
                onFinished(true)
        })
        nodeTwo.runAction(SCNAction.sequence([moveDownAction, waitAction, danceRightAction, danceRightAction.reversed(), danceLeftAction, danceLeftAction.reversed(), danceRightAction, danceRightAction.reversed(), danceLeftAction, danceLeftAction.reversed(), SCNAction.removeFromParentNode()]))
    }
        
    
}

func moveUpAndRotateCard(_ node: SCNNode, _ cameraEulers: vector_float3?, _ cameraNode: SCNNode!, onFinished: @escaping (Bool) -> Void) {
    
    switch GameUtils.shared.mode {
        
    case .ARKit:
        let moveUpYAction = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 1)
        moveUpYAction.timingMode = .easeOut
        let rotateXAction = SCNAction.rotateBy(x: CGFloat.pi/2+CGFloat(cameraEulers!.x), y: 0, z: 0, duration: 1)
        let rotateXFlipAction = SCNAction.rotateBy(x: CGFloat.pi, y: 0, z: 0, duration: 0.5)
        let groupMoveUpAndFlip = SCNAction.group([moveUpYAction,rotateXAction])
        node.runAction(SCNAction.sequence([groupMoveUpAndFlip, SCNAction.wait(duration: 2), rotateXFlipAction, SCNAction.wait(duration: 1), SCNAction.removeFromParentNode()]), completionHandler: {
            print("finished animating")
            onFinished(true)
            
        })
        
    case .SceneKit:
        let moveAction = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        moveAction.timingMode = .easeOut
        let rotateXAxis = SCNAction.rotateTo(x: convertToRadians(angle: 60), y: 0, z: 0, duration: 1)
        let waitAction = SCNAction.wait(duration: 2)
        let rotateYAxis = SCNAction.rotateBy(x: CGFloat.pi, y: 0, z: 0, duration: 0.5)
        let groupedAction = SCNAction.group([moveAction, rotateXAxis])
        let removeNode = SCNAction.removeFromParentNode()
        node.runAction(SCNAction.sequence([
            groupedAction,waitAction, rotateYAxis, waitAction, removeNode
            ]), completionHandler: {
                print("finished animating")
                onFinished(true)
        })
    }
    
}

