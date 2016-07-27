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

private let FlickrError     = "Flickr API had invalid data while fetching images! Please retry."
private let NetworkError    = "Network error! Please check your connection."



class MTNetworkHelper: NSObject {
    
    static func fetchAPIResponseWithCompletion (completion: (String?) -> Void) {
        
        Alamofire.request(.GET, FlickrAPIURL, parameters: FlickrAPIParams)
            .responseString { response in
                
                if let value = response.result.value {
                    
                    completion(value)
                    
                } else {
                    
                    completion(nil)
                }
        }
    }
    
    static func fetchImageLinksWithCompletion (completion: (imageLinks: [String]?, error: String) -> Void) {
        
        Alamofire.request(.GET, FlickrAPIURL, parameters: FlickrAPIParams)
        .validate()
        .responseString { response in
                
            if let value = response.result.value {
                
                let cleanJSON = MTNetworkHelper.sanitizedString(value)
                
                if let links = MTNetworkHelper.parseLinksFromJSONString(cleanJSON) {
                    
                    completion(imageLinks: links, error: "")
                }
                else {
                    
                    completion(imageLinks: nil, error: FlickrError)
                }
            }
            else {
                
                print("Status Code: \(response.response?.statusCode)")
                completion(imageLinks: nil, error: NetworkError)
            }
        }
    }
    
    static func sanitizedString(jString: String) -> String {
        
        if let regex = try? NSRegularExpression(pattern: "<\\/?[^>]+>", options: .CaseInsensitive) {
            
            let modString = regex.stringByReplacingMatchesInString(jString, options: .WithTransparentBounds, range: NSMakeRange(0, jString.characters.count), withTemplate: "")
            
            return modString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
        }
        
        return jString
    }
    
    static func parseLinksFromJSONString(jsonString: String) -> [String]? {
        
        let data    = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        do {
            
            let json    = try JSON(data: data ?? NSData())
            let items   = try json.array("items")
            
            var links   = [String]()
            
            for item in items {
                
                let linkStr = try item.string("media", "m")
                links.append(linkStr)
            }
            
            print("\(items.count) image links found!")
            return links
            
        } catch let error {
            
            print("Error! \(error)")
            
            return nil
        }
    }
}
