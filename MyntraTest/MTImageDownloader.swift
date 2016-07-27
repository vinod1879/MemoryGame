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
    
    let imageLinks  : [String]
    weak var delegate    : MTImageDownloaderDelegate?
    
    private var downloadedImages : [UIImage]
    
    
    init(imageLinks: [String]) {
        
        self.imageLinks     = imageLinks
        downloadedImages    = [UIImage]()
    }
    
    func startDownloads () {
        
        resume()
    }
    
    private func resume () {
        
        if downloadedImages.count == imageLinks.count {
            
            delegate?.imageDownloader(self, finishedWithImages: downloadedImages)
            return
        }
        
        if downloadedImages.count > imageLinks.count { return } // Safety check
        
        let urlStr = imageLinks[downloadedImages.count]
        
        guard let url = NSURL(string: urlStr) else { return }
        
        let downloader = SDWebImageDownloader.sharedDownloader()
        
        downloader.downloadImageWithURL(url, options: [], progress: nil) { (image, data, error, finished) in
     
            if let img = image {
                
                self.downloadedImages.append(img)
                self.resume()
            }
        }
    }
}
