//
//  MTImageCell.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit
import SDWebImage

class MTImageCell: UICollectionViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet private var imageView : UIImageView!
    
    //MARK:- Public API
    
    func setImage(image: UIImage?) {
        
        imageView.image = image
    }
}
