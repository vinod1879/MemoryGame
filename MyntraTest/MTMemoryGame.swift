//
//  MTMemoryGame.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit

protocol MTMemoryGameDelegate : class {
    
    func memoryGameStartedInit(memoryGame: MTMemoryGame)
    func memoryGameInitializationComplete(memorygame: MTMemoryGame)
    func memoryGameInitializationFailed(memoryGame: MTMemoryGame, error: String)
    func memoryGame(memoryGame: MTMemoryGame, updatedTimeString timeString: String)
    func memoryGameTimerExpired(memoryGame: MTMemoryGame)
    func memoryGame(memoryGame: MTMemoryGame, selectedImage image: UIImage, withIndex index: Int)
    func memoryGameCompletedSuccessfully(memoryGame: MTMemoryGame)
}

class MTMemoryGame: NSObject {
    
    //MARK:- Public Vars
    
    var initComplete  = false
    weak var delegate : MTMemoryGameDelegate?
    
    //MARK:- Private Vars
    
    private let numberOfTiles   : Int
    private var dictionary      : [Int : UIImage]
    private var indices         : [Int]
    private let timer           : MTTimer
    private var timerRunning    = false
    private var imageDownloader : MTImageDownloader!
    private var numberOfGuesses = 0
    
    //MARK:- Init and Public API
    
    init(numberOfTiles: Int) {
        
        self.numberOfTiles = numberOfTiles
        
        indices     = [Int]()
        dictionary  = [Int: UIImage]()
        timer       = MTTimer()
        
        super.init()
    }
    
    func initialize() {
        
        delegate?.memoryGameStartedInit(self)
        fetchImages()
    }
    
    func startTimerWithTimeInterval(timeInterval: NSTimeInterval) {
        
        timer.delegate  = self
        timerRunning    = true
        timer.startWithTimeInterval(timeInterval)
    }
    
    func handleCorrectAnswerAtIndex (index : Int) {
        
        guard let rIndex = indices.indexOf(index) else { return }
        
        numberOfGuesses += 1
        
        indices.removeAtIndex(rIndex)
        
        if indices.count == 0 {
            
            delegate?.memoryGameCompletedSuccessfully(self)
            
        } else {
            
            selectRandomImage()
        }
    }
    
    func handleIncorrectAnswerAtIndex (index: Int) {
        
        numberOfGuesses += 1
    }
    
    func imageAtIndex(index: Int) -> UIImage? {
        
        if timerRunning || !indices.contains(index) {
            
            return dictionary[index]
        }

        return nil
    }
    
    func endGame () {
        
        timer.stop()
    }
    
    func score () -> String {
        
        let correctGuesses = numberOfTiles - indices.count
        
        let score = "Score: \(correctGuesses)/\(numberOfGuesses)"
        
        return score
    }
    
    //MARK:- Private
    
    private func selectRandomImage () {
        
        let randomIndex = MTUtility.randomNumberWithLimit(indices.count)
        
        if randomIndex >= 0 {
            
            let element = indices[randomIndex]
            let image   = dictionary[element]
            
            delegate?.memoryGame(self, selectedImage: image!, withIndex: element)
        }
    }
}

extension MTMemoryGame : MTTimerDelegate {
    
    func timerTimedOut(timer: MTTimer) {
        
        timerRunning = false
        delegate?.memoryGameTimerExpired(self)
        selectRandomImage()
    }
    
    func timer(timer: MTTimer, updatedTimeLeft timeLeft: Double, withFormattedString: String) {
        
        delegate?.memoryGame(self, updatedTimeString: withFormattedString)
    }
}

extension MTMemoryGame : MTImageDownloaderDelegate {
    
    private func fetchImages () {
        
        MTNetworkHelper.fetchImageLinksWithCompletion { (imageLinks, message) in
            
            let success             = imageLinks != nil
            
            if success {
                
                let requiredLinks = Array(imageLinks![0..<self.numberOfTiles])
                self.imageDownloader = MTImageDownloader(imageLinks: requiredLinks)
                self.imageDownloader.delegate = self
                self.imageDownloader.startDownloads()
                
            } else {
             
                self.delegate?.memoryGameInitializationFailed(self, error: message)
            }
        }
    }
    
    func imageDownloader(imageDownloader: MTImageDownloader, finishedWithImages images: [UIImage]) {
        
        print("Images downloaded!")
        for index in 0 ..< images.count {
            
            indices.append(index)
            dictionary[index] = images[index]
        }
        
        dispatch_async(dispatch_get_main_queue()) { 
        
            self.initComplete = true
            self.delegate?.memoryGameInitializationComplete(self)
        }
    }
}
