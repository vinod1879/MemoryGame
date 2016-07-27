//
//  MTMemoryGame.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit

protocol MTMemoryGameDelegate : class {
    
    func memoryGame(memoryGame: MTMemoryGame, updatedTimeLeft timeLeft: NSTimeInterval)
}

class MTMemoryGame: NSObject {

}
