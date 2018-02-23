//
//  SoundsSingleton.swift
//  ChupitApp
//
//  Created by Alessandro Minopoli on 23/02/18.
//  Copyright © 2018 Marco Falanga. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds {
    
    static let shared = Sounds()
    private init() {}
    
    var backgroundMusicPlayer: AVAudioPlayer!
    
    func playBackgroundMusic(fileName: String) {
        let resourceUrl = Bundle.main.url(forResource: fileName, withExtension: nil)
        guard let url = resourceUrl else {
            print("Could not find file: \(fileName)")
            return
        }
        do {
                try self.backgroundMusicPlayer = AVAudioPlayer(contentsOf: url)
                self.backgroundMusicPlayer.numberOfLoops = -1
                self.backgroundMusicPlayer.prepareToPlay()
                self.backgroundMusicPlayer.play()
                self.backgroundMusicPlayer.setVolume(1, fadeDuration: 1)
        } catch {
            print("Could not create audio player")
            return
        }
    }
    
    func lowerVolume() {
        if backgroundMusicPlayer != nil {
            backgroundMusicPlayer.setVolume(0, fadeDuration: 1)
        }
    }
    
    
}

