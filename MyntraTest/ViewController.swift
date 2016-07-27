//
//  ViewController.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit

private let ImageCellId             = "MTImageCell"
private let cellWidth : CGFloat     = CGRectGetWidth(UIScreen.mainScreen().bounds) / 3
private let cellSize                = CGSizeMake(cellWidth, cellWidth)
private let numberOfCells           = 9
private let timerDuration           = 15.0

private let downloadStartMessage    = "Fetching image list..."
private let downloadSuccessMessage  = "Memorise the images"
private let errorTitle              = "Error!"

class ViewController: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet private var questionImageView     : UIImageView!
    @IBOutlet private var questionImageWidth    : NSLayoutConstraint!
    @IBOutlet private var imagesCollection      : UICollectionView!
    @IBOutlet private var activityIndicator     : UIActivityIndicatorView!
    
    
    //MARK:- Private Vars
    
    private var memoryGame          : MTMemoryGame!
    private var secretIndex         : Int?
    
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
        
        setupGame()
    }
    
    //MARK:- Private API
    
    private func setupGame () {
        
        questionImageView.image = nil
        
        memoryGame = MTMemoryGame(numberOfTiles: numberOfCells)
        memoryGame.delegate = self
        
        memoryGame.initialize()
    }
}

extension ViewController : MTMemoryGameDelegate {
    
    func memoryGameStartedInit(memoryGame: MTMemoryGame) {
        
        print("init start")
        imagesCollection.hidden = true
        activityIndicator.startAnimating()
    }
    
    func memoryGameInitializationComplete(memorygame: MTMemoryGame) {
        
        print("init complete")
        imagesCollection.hidden = false
        activityIndicator.stopAnimating()
        
        memoryGame.startTimerWithTimeInterval(timerDuration)
        imagesCollection.reloadData()
    }
    
    func memoryGameInitializationFailed(memoryGame: MTMemoryGame, error: String) {
        
        print("init failed")
        
        activityIndicator.stopAnimating()
        notifyMessage(error, withTitle: "Error!")
    }
    
    func memoryGame(memoryGame: MTMemoryGame, updatedTimeString timeString: String) {
     
        print("time update")
        navigationItem.title = timeString
    }
    
    func memoryGameTimerExpired(memoryGame: MTMemoryGame) {
        
        imagesCollection.reloadData()
    }
    
    func memoryGameCompletedSuccessfully(memoryGame: MTMemoryGame) {
        
        print("~~~ Success ~~~")
        navigationItem.title = "Success!"
    }
    
    func memoryGame(memoryGame: MTMemoryGame, selectedImage image: UIImage, withIndex index: Int) {
        
        print("Image Presented")
        questionImageView.image = image
        secretIndex             = index
    }
}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfCells
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ImageCellId, forIndexPath: indexPath) as! MTImageCell
        
        let image = memoryGame.imageAtIndex(indexPath.row)
        
        cell.setImage(image)
        

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let index = secretIndex {
            
            if indexPath.row == index {
                
                memoryGame.handleCorrectAnswerAtIndex(index)
                collectionView.reloadItemsAtIndexPaths([indexPath])
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
}
