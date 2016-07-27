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
    
    func imageCell(imageCell : MTImageCell, downloadedImage image: UIImage, atIndex index: Int)
}

class MTImageCell: UICollectionViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet private var imageView : UIImageView!
    
    //MARK:- Public Var
    
    var index       : Int = 0
    var delegate    : MTImageCellDelegate?
    
    //MARK:- Public API
    
    func setImageWithLink(imageLink : String, hidden: Bool) {
        
        imageView.hidden = hidden
     
        guard let url = NSURL(string: imageLink) else { return }
        
        imageView.sd_setImageWithURL(url) { (image, error, cacheType, url) in
            
            if error == nil {
                
                self.delegate?.imageCell(self, downloadedImage: image, atIndex: self.index)
            }
        }
    }
}
