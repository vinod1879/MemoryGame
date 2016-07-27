//
//  MTUtility.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit

class MTUtility: NSObject {
    
    static func randomNumberWithLimit(limit: Int) -> Int {
        
        let random = Int(arc4random_uniform(UInt32(limit)))
        
        return random
    }
}
