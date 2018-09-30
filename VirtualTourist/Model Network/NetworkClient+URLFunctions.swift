//
//  NetworkClient+URLFunctions.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/21/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

extension NetworkClient {
    
    func flickrURLFromParameters(_ parameters: [String:AnyObject]) -> URL {
        
        var components = URLComponents()
        
        components.scheme     = Constants.Flickr.APIScheme
        components.host       = Constants.Flickr.APIHost
        components.path       = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
}
