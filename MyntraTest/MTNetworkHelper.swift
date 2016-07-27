//
//  MTNetworkHelper.swift
//  MyntraTest
//
//  Created by Vinod Vishwanath on 27/07/16.
//  Copyright © 2016 Vinod Vishwanath. All rights reserved.
//

import UIKit
import Alamofire
import Freddy

private let FlickrAPIURL    = "https://api.flickr.com/services/feeds/photos_public.gne"
private let FlickrAPIParams = ["format": "json", "lang": "en-us", "nojsoncallback": "1"]

class MTNetworkHelper: NSObject {
    
    static func fetchImageLinksWithCompletion (completion: (imageLinks: [String]?) -> Void) {
        
        Alamofire.request(.GET, FlickrAPIURL, parameters: FlickrAPIParams)
        .validate()
        .responseString { response in
                
            if let value = response.result.value {
                
                let cleanJSON = MTNetworkHelper.cleanupJsonString(value)
                
                print("\(value.characters.count) -> \(cleanJSON.characters.count)")
                
                let data    = cleanJSON.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                
                do {
                    
                    let json    = try JSON(data: data ?? NSData())
                    let items   = try json.array("items")
                    
                    var links   = [String]()
                    
                    for item in items {
                        
                        let linkStr = try item.string("media", "m")
                        links.append(linkStr)
                    }
                    
                    print("\(items.count) image links found!")
                    completion(imageLinks: links)
                    
                } catch let error {
                    
                    print("Error! \(error)")
                    
                    completion(imageLinks: nil)
                }
            }
            else {
                
                print("Status Code: \(response.response?.statusCode)")
                print("image fetch failed...\(response.result.error)")
                completion(imageLinks: nil)
            }
        }
    }
    
    static func cleanupJsonString(jString: String) -> String {
        
        if let regex = try? NSRegularExpression(pattern: "<\\/?[^>]+>", options: .CaseInsensitive) {
            
            let modString = regex.stringByReplacingMatchesInString(jString, options: .WithTransparentBounds, range: NSMakeRange(0, jString.characters.count), withTemplate: "")
            
            return modString
        }
        
        return jString
    }
}
