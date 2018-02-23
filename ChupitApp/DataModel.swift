//
//  DataModel.swift
//  ChupitApp
//
//  Created by Alessandro Minopoli on 17/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import Foundation




class Deck {
    
    var cards = [Card]()
    
    init() {
        initializeDeck()
    }
    
    func numberOfCardsRemaining() -> Int {
        return cards.endIndex
    }
    
    func randomCardFromDeck() -> Card {
        let randomCard = Int(arc4random_uniform(UInt32(numberOfCardsRemaining())))
        return removeCardFromDeck(cardIndex: randomCard)
    }
    
    func removeCardFromDeck(cardIndex: Int) -> Card {
        return cards.remove(at: cardIndex)
    }
    
    private func initializeDeck() {
        cards.append(Card(color: "black", identifier: "AceOfSpades"))
        cards.append(Card(color: "black", identifier: "TwoOfSpades"))
        cards.append(Card(color: "black", identifier: "ThreeOfSpades"))
        cards.append(Card(color: "black", identifier: "FourOfSpades"))
        cards.append(Card(color: "black", identifier: "FiveOfSpades"))
        cards.append(Card(color: "black", identifier: "SixOfSpades"))
        cards.append(Card(color: "black", identifier: "SevenOfSpades"))
        cards.append(Card(color: "black", identifier: "EightOfSpades"))
        cards.append(Card(color: "black", identifier: "NineOfSpades"))
        cards.append(Card(color: "black", identifier: "TenOfSpades"))
        cards.append(Card(color: "black", identifier: "JackOfSpades"))
        cards.append(Card(color: "black", identifier: "QueenOfSpades"))
        cards.append(Card(color: "black", identifier: "KingOfSpades"))
        cards.append(Card(color: "black", identifier: "AceOfClubs"))
        cards.append(Card(color: "black", identifier: "TwoOfClubs"))
        cards.append(Card(color: "black", identifier: "ThreeOfClubs"))
        cards.append(Card(color: "black", identifier: "FourOfClubs"))
        cards.append(Card(color: "black", identifier: "FiveOfClubs"))
        cards.append(Card(color: "black", identifier: "SixOfClubs"))
        cards.append(Card(color: "black", identifier: "SevenOfClubs"))
        cards.append(Card(color: "black", identifier: "EightOfClubs"))
        cards.append(Card(color: "black", identifier: "NineOfClubs"))
        cards.append(Card(color: "black", identifier: "TenOfClubs"))
        cards.append(Card(color: "black", identifier: "JackOfClubs"))
        cards.append(Card(color: "black", identifier: "QueenOfClubs"))
        cards.append(Card(color: "black", identifier: "KingOfClubs"))
        cards.append(Card(color: "red", identifier: "AceOfHearts"))
        cards.append(Card(color: "red", identifier: "TwoOfHearts"))
        cards.append(Card(color: "red", identifier: "ThreeOfHearts"))
        cards.append(Card(color: "red", identifier: "FourOfHearts"))
        cards.append(Card(color: "red", identifier: "FiveOfHearts"))
        cards.append(Card(color: "red", identifier: "SixOfHearts"))
        cards.append(Card(color: "red", identifier: "SevenOfHearts"))
        cards.append(Card(color: "red", identifier: "EightOfHearts"))
        cards.append(Card(color: "red", identifier: "NineOfHearts"))
        cards.append(Card(color: "red", identifier: "TenOfHearts"))
        cards.append(Card(color: "red", identifier: "JackOfHearts"))
        cards.append(Card(color: "red", identifier: "QueenOfHearts"))
        cards.append(Card(color: "red", identifier: "KingOfHearts"))
        cards.append(Card(color: "red", identifier: "AceOfDiamonds"))
        cards.append(Card(color: "red", identifier: "TwoOfDiamonds"))
        cards.append(Card(color: "red", identifier: "ThreeOfDiamonds"))
        cards.append(Card(color: "red", identifier: "FourOfDiamonds"))
        cards.append(Card(color: "red", identifier: "FiveOfDiamonds"))
        cards.append(Card(color: "red", identifier: "SixOfDiamonds"))
        cards.append(Card(color: "red", identifier: "SevenOfDiamonds"))
        cards.append(Card(color: "red", identifier: "EightOfDiamonds"))
        cards.append(Card(color: "red", identifier: "NineOfDiamonds"))
        cards.append(Card(color: "red", identifier: "TenOfDiamonds"))
        cards.append(Card(color: "red", identifier: "JackOfDiamonds"))
        cards.append(Card(color: "red", identifier: "QueenOfDiamonds"))
        cards.append(Card(color: "red", identifier: "KingOfDiamonds"))
    }
    
}



class Card {
    let color: String
    let identifier: String
    
    init(color: String, identifier: String) {
        self.color = color
        self.identifier = identifier
    }
    
}
