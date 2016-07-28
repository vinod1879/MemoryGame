//
//  ViewController.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit

private let ImageCellId             = "MTImageCell"
private let cellWidth : CGFloat     = CGRectGetWidth(UIScreen.mainScreen().bounds) / 3 - 3
private let cellSize                = CGSizeMake(cellWidth, cellWidth)

struct Prompts {
    
    static let Initializing = "Fetching images"
    static let StartGame    = "Memorise the images"
    static let NetworkIssue = "Hit Refresh to try again"
    static let RightAnswer  = "Correct!"
    static let WrongAnswer  = "Wrong :("
    static let GameOver     = "Well done!"
}

struct Titles {
    
    static let Error        = "Error!"
    static let GameOver     = "Game Over"
}

struct Config {
    
    static let NumberOfTiles = 9
    static let TimerDuration = 15.0
}


class ViewController: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet private var questionImageView     : UIImageView!
    @IBOutlet private var questionImageWidth    : NSLayoutConstraint!
    @IBOutlet private var imagesCollection      : UICollectionView!
    @IBOutlet private var activityIndicator     : UIActivityIndicatorView!
    @IBOutlet private var refreshButtonItem     : UIBarButtonItem!
    
    
    //MARK:- Private Vars
    
    private var memoryGame          : MTMemoryGame!
    private var secretIndex         : Int?
    private var animation           : CATransition?
    
    //MARK:- View Load

    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionImageWidth.constant = cellSize.width
        
        setupGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- IBActions
    
    @IBAction func refreshButtonTapped (sender: AnyObject) {
        
        memoryGame?.endGame()
        navigationItem.title = nil
        
        setupGame()
    }
    
    //MARK:- Private API
    
    private func setupGame () {
        
        questionImageView.image = nil
        
        memoryGame = MTMemoryGame(numberOfTiles: Config.NumberOfTiles)
        memoryGame.delegate = self
        
        memoryGame.initialize()
    }
}

extension ViewController : MTMemoryGameDelegate {
    
    func memoryGameStartedInit(memoryGame: MTMemoryGame) {
        
        print("init start")
        imagesCollection.hidden     = true
        refreshButtonItem.enabled   = false
        activityIndicator.startAnimating()
        
        navigationItem.prompt = Prompts.Initializing
    }
    
    func memoryGameInitializationComplete(memorygame: MTMemoryGame) {
        
        print("init complete")
        imagesCollection.hidden     = false
        refreshButtonItem.enabled   = true
        activityIndicator.stopAnimating()
        
        memoryGame.startTimerWithTimeInterval(Config.TimerDuration)
        imagesCollection.userInteractionEnabled = false
        imagesCollection.reloadData()
        
        navigationItem.prompt = Prompts.StartGame
    }
    
    func memoryGameInitializationFailed(memoryGame: MTMemoryGame, error: String) {
        
        print("init failed")
        
        refreshButtonItem.enabled   = true
        activityIndicator.stopAnimating()
        notifyMessage(error, withTitle: Titles.Error)
        
        navigationItem.prompt = Prompts.NetworkIssue
    }
    
    func memoryGame(memoryGame: MTMemoryGame, updatedTimeString timeString: String) {
     
        print("time update")
        navigationItem.title = timeString
    }
    
    func memoryGameTimerExpired(memoryGame: MTMemoryGame) {
        
        imagesCollection.userInteractionEnabled = true
        imagesCollection.reloadData()
    }
    
    func memoryGameCompletedSuccessfully(memoryGame: MTMemoryGame) {
        
        print("~~~ Success ~~~")
        
        imagesCollection.userInteractionEnabled = false
        navigationItem.title = Titles.GameOver
        navigationItem.prompt = memoryGame.score()
    }
    
    func memoryGame(memoryGame: MTMemoryGame, selectedImage image: UIImage, withIndex index: Int) {
        
        print("Image Presented")
        questionImageView.image = image
        secretIndex             = index
        
        navigationItem.title = memoryGame.score()
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return Config.NumberOfTiles
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCellId, forIndexPath: indexPath) as! MTImageCell
        
        let image = memoryGame.imageAtIndex(indexPath.row)
        
        cell.setImage(image)
        cell.contentView.layer.addAnimation(self.animationInstance(), forKey: nil)

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let index = secretIndex {
            
            if indexPath.row == index {
                
                navigationItem.prompt = Prompts.RightAnswer
                
                memoryGame.handleCorrectAnswerAtIndex(index)
                collectionView.reloadItemsAtIndexPaths([indexPath])                
                
            } else if memoryGame.imageAtIndex(indexPath.row) == nil {
                
                memoryGame.handleIncorrectAnswerAtIndex(indexPath.row)
                navigationItem.prompt = Prompts.WrongAnswer
                navigationItem.title = memoryGame.score()
            }
        }
    }
}

extension ViewController {
    
    private func notifyMessage(message: String?, withTitle title: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        alertController.addAction(action)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func animationInstance () -> CATransition {
        
        if let anim = self.animation {
            
            return anim
        }
        
        let animation = CATransition()
        animation.delegate = self
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = true
        animation.type = kCATransitionReveal
        animation.subtype = kCATransitionFromRight
        
        self.animation = animation
        
        return animation
    }
}
