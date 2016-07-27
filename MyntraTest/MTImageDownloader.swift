//
//  MTImageDownloader.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit
import SDWebImage

protocol MTImageDownloaderDelegate : class {
    
    func imageDownloader(imageDownloader: MTImageDownloader, finishedWithImages: [UIImage])
}

class MTImageDownloader: NSObject {
    
    //MARK:- Public Vars
    
    let imageLinks          : [String]
    weak var delegate       : MTImageDownloaderDelegate?
    
    //MARK:- Private Vars
    
    private var downloadedImages : [UIImage]
    
    //MARK:- Init and Public API
    
    init(imageLinks: [String]) {
        
        self.imageLinks     = imageLinks
        downloadedImages    = [UIImage]()
    }
    
    func startDownloads () {
        
        enqueueDownloads()
    }
    
    //MARK:- Private API
    
    private func checkStatus () {
        
        if downloadedImages.count == imageLinks.count {
            
            delegate?.imageDownloader(self, finishedWithImages: downloadedImages)
        }
    }
    
    private func enqueueDownloads () {
        
        for link in imageLinks {
            
            let downloader = SDWebImageDownloader.sharedDownloader()
            
            guard let url = NSURL(string: link) else { continue }
            
            downloader.downloadImageWithURL(url, options: [], progress: nil, completed: { (image, data, error, finished) in
                
                if let img = image {
                    
                    self.downloadedImages.append(img)
                    self.checkStatus()
                }
            })
        }
    }
}
