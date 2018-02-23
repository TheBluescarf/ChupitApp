//
//  GameUtils.swift
//  ChupitApp
//
//  Created by Alessandro Minopoli on 15/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit

public enum GameStateType {
    case playing
    case initializing
    case gameOver
}

public enum GameMode {
    case ARKit
    case SceneKit
}

@objc protocol GameInteractionProtocol: class {
    //red = 0, black = 1
    @objc optional func choiceButton(color: Int)
    @objc optional func newPlayer()
    @objc optional func leaveTable()
    @objc optional func endGame()
}

@objc protocol ChildToParentProtocol: class {
    @objc optional func hideChoices(hide: Bool)
    @objc optional func winPick(win: Bool)
    @objc optional func showTrackingLabel(hide: Bool)
    @objc optional func switchController(type: String)
    @objc optional func goToReportController()
}

class GameUtils {
    
    
    var state = GameStateType.initializing
    
    private init() {}
    
    static let shared = GameUtils()
    
    var sounds: [String: SCNAudioSource] = [:]
    
    var mode = GameMode.SceneKit
    
    var spawnedBaloons: Int = 0
}

let UIColorList:[UIColor] = [
    UIColor.red,
    UIColor.blue,
    UIColor.yellow,
    UIColor.cyan,
    UIColor.gray,
    UIColor.green,
    UIColor.magenta,
    UIColor.orange,
    UIColor.purple,
    UIColor.pink
]

extension UIColor {
    
    public static func random() -> UIColor {
        let maxValue = UIColorList.count
        let rand = Int(arc4random_uniform(UInt32(maxValue)))
        return UIColorList[rand]
    }
    
    public static var pink: UIColor {
        return UIColor(red: 233/255, green: 150/255, blue: 143/255, alpha: 1.0)
    }
}

