//
//  MTMemoryGame.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit

protocol MTMemoryGameDelegate : class {
    
    func memoryGameInitializationComplete(memorygame: MTMemoryGame)
    func memoryGame(memoryGame: MTMemoryGame, updatedTimeString timeString: String)
    func memoryGameTimerExpired(memoryGame: MTMemoryGame)
    func memoryGame(memoryGame: MTMemoryGame, selectedImage image: UIImage, withIndex index: Int)
    func memoryGameCompletedSuccessfully(memoryGame: MTMemoryGame)
}

class MTMemoryGame: NSObject {
    
    //MARK:- Delegate
    
    var delegate : MTMemoryGameDelegate?
    
    //MARK:- Private Vars
    
    private let numberOfTiles   : Int
    private var dictionary      : [Int : UIImage]
    private var indices         : [Int]
    private let timer           : MTTimer
    
    //MARK:- Init and Public API
    
    init(numberOfTiles: Int) {
        
        self.numberOfTiles = numberOfTiles
        
        indices     = [Int]()
        dictionary  = [Int: UIImage]()
        timer       = MTTimer()
        
        super.init()
    }
    
    func setImage(image: UIImage, atIndex index: Int) {
        
        indices.append(index)
        dictionary[index] = image
        
        if dictionary.count == numberOfTiles {
            
            delegate?.memoryGameInitializationComplete(self)
        }
    }
    
    func startTimerWithTimeInterval(timeInterval: NSTimeInterval) {
        
        timer.delegate = self
        timer.startWithTimeInterval(timeInterval)
    }
    
    func handleCorrectAnswerAtIndex (index : Int) {
        
        if let rIndex = indices.indexOf(index) {
            
            indices.removeAtIndex(rIndex)
        }
        
        if indices.count == 0 {
            
            delegate?.memoryGameCompletedSuccessfully(self)
            
        } else {
            
            selectRandomImage()
        }
    }
    
    //MARK:- Private
    
    private func selectRandomImage () {
        
        let randomIndex = MTUtility.randomNumberWithLimit(indices.count)
        
        if randomIndex >= 0 {
            
            let image = dictionary[randomIndex]
            
            delegate?.memoryGame(self, selectedImage: image!, withIndex: randomIndex)
            
        }
    }
}

extension MTMemoryGame : MTTimerDelegate {
    
    func timerTimedOut(timer: MTTimer) {
        
        delegate?.memoryGameTimerExpired(self)
        selectRandomImage()
    }
    
    func timer(timer: MTTimer, updatedTimeLeft timeLeft: Double, withFormattedString: String) {
        
        delegate?.memoryGame(self, updatedTimeString: withFormattedString)
    }
}
