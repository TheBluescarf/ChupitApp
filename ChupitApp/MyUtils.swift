//
//  MyUtils.swift
//  ChupitApp
//
//  Created by Marco Falanga on 06/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension UIColor {
    static let myOrange = UIColor(red: 238/255, green: 103/255, blue: 61/255, alpha: 1)
}

extension UIImageView {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

class User {
    var image: UIImage = UIImage()
    var chupitos: Int = 0
    var consecutiveChupitos: Int = 0
    var rounds: Int = 0
    var isActive: Bool = true
    var imagesArray: [UIImage] = []
    var username: String = ""
}


final class Singleton {
    
    var playersNumber: Int = 0
    
    var users: [User] = []
    var deck = Deck()
    static var shared = Singleton()
    
    func repeatGame() {
        for user in users {
            user.chupitos = 0
            user.consecutiveChupitos = 0
            user.isActive = true
            user.rounds = 0
        }
        deck = Deck()
        playersNumber = users.count
    }
    
    func reset() {
        playersNumber = 0
        users = []
        deck = Deck()
    }
    
    func addOne(image: UIImage) {
        let user = User()
        user.image = image
        users.append(user)
    }
    
    func addOneAtIndex(image: UIImage, index: Int) {
        let user = User()
        user.image = image
        users.insert(user, at: index)
    }
    
    func replaceAtIndex(image: UIImage, index: Int) {
        
        if index < Singleton.shared.users.count {
            let user = User()
            user.image = image
            users.remove(at: index)
            users.insert(user, at: index)
        }
        else {
            print("___OUT OF INDEX___")
        }
    }
    
    func addImageInCollectionAtUserIndex(image: UIImage, index: Int) {
        if index < Singleton.shared.users.count {
            Singleton.shared.users[index].imagesArray.append(image)
        }
        else {
            print("___OUT OF INDEX___")
        }
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return (lhs.chupitos) == (rhs.chupitos)
    }
}

extension User: Comparable {
    static func <(lhs: User, rhs: User) -> Bool {
        return (lhs.chupitos) < (rhs.chupitos)
    }
}

let funnyPhotosString: [String] = {
    return ["wet kiss an invisible partner!",
            "pretend to be a gorilla",
            "make your tounge touch the nose",
            "remove that boogie from your nose!",
            "kiss the guy/girl to your left",
            "pretend to be a giraffe"]
}()

var funnyNamesString: [String] = {
    return ["Milker",
            "Licker",
            "Fat ass",
            "Screamer",
            "Banana bender",
            "Shy guy",
            "Flatulance",
            "The Lone Ranger",
            "Stalker365",
            "Deep Toot",
            "Big daddy",
            "Cockmuppet",
            "Assclown",
            "Fuckface",
            "Dicknose",
            "Pigfucker",
            "Butt monkey",
            "Village idiot",
            "Weirdo",
            "Porker",
            "Poo-poo head",
            "Vaginal leakage",
            "Ballsack",
            "Buttjuice",
            "Turkey"]
}()
