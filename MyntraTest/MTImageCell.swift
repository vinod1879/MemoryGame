//
//  MTImageCell.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit
import SDWebImage

protocol MTImageCellDelegate : class {
    
    func imageCell(imageCell : MTImageCell, downloadedImageAtIndex index: Int)
}

class MTImageCell: UICollectionViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet private var imageView : UIImageView!
    
    //MARK:- Public Var
    
    var index       : Int = 0
    var delegate    : MTImageCellDelegate?
    
    //MARK:- Public API
    
    func setImageWithLink(imageLink : String) {
     
        guard let url = NSURL(string: imageLink) else { return }
        
        imageView.sd_setImageWithURL(url) { _ in
         
            
            self.delegate?.imageCell(self, downloadedImageAtIndex: self.index)
        }
    }
}
