//
//  MTNetworkHelper.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let FlickrAPIURL = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&lang=en-us&nojsoncallback=1"

class MTNetworkHelper: NSObject {
    
    static func fetchImageLinksWithCompletion (completion: (imageLinks: [String]?) -> Void) {
        
        Alamofire.request(.GET, FlickrAPIURL)
        .validate()
        .responseJSON { response in
                
            if let value = response.result.value {
                
                let json = JSON(value)
                
                guard let items = json["items"].array else { completion(imageLinks: nil); return }
                
                var links = [String]()
                
                for item in items {
                    
                    let linkStr = item["media"]["m"].string ?? ""
                    
                    links.append(linkStr)
                }
                
                print("\(items.count) image links found!")
                
                completion(imageLinks: links)
            }
            else {
                
                print("Status Code: \(response.response?.statusCode)")
                print("image fetch failed...\(response.result.error)")
                completion(imageLinks: nil)
            }
        }
    }
}
