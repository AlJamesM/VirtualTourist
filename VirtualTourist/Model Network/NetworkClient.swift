//
//  NetworkClient.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/21/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation

class NetworkClient: NSObject {
    
    var session = URLSession.shared
    static let shared = NetworkClient()
    
    override init() {
        super.init()
    }
    
    func getPhotos(latitude: Double?, longitude: Double?, page: Int, completion: @escaping (_ photos : [[String: AnyObject]]?, _ pages : Int, _ error : String?) -> Void) {
        networkRequest(requestPhotosWithPage(latitude: latitude, longitude: longitude, page: page), completion: completion)
    }
    
    func requestPhotosWithPage(latitude: Double?, longitude: Double?, page: Int?) -> URLRequest {
        
        let methodParameters = [
            Constants.FlickrParameterKeys.Method         : Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey         : Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.BoundingBox    : bboxString(pLatitude: latitude, pLongitude: longitude),
            Constants.FlickrParameterKeys.SafeSearch     : Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras         : Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.Format         : Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.PerPage        : Constants.FlickrParameterValues.PerPageCount,
            Constants.FlickrParameterKeys.Page           : "\(page!)"
        ]
        
        let request = URLRequest(url: flickrURLFromParameters(methodParameters as [String: AnyObject]))
        
        return request
    }
    
    private func networkRequest(_ request: URLRequest, completion: @escaping (_ photos : [[String: AnyObject]]?, _ pages : Int, _ error : String?) -> Void) {
        
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, 0, error)
                }
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            let parsedResult: [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                sendError("Could not parse the data as JSON.")
                return
            }
            
            // Did Flickr return an error
            guard let status = parsedResult[Constants.FlickrResponseKeys.Status] as? String, status == Constants.FlickrResponseValues.OKStatus else {
                sendError("Flickr API returned an error.")
                return
            }
            
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                sendError("No data from parsed result.")
                return
            }
            
            guard let totalPages = photosDictionary[Constants.FlickrResponseKeys.Pages] as? Int else {
                sendError("No page information.")
                return
            }
            
            guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                sendError("No data from parsed result.")
                return
            }
            
            DispatchQueue.main.async {
                completion(photosArray, totalPages, nil)
            }
        }
        task.resume()
    }
    
    private func bboxString(pLatitude: Double?, pLongitude: Double?) -> String {
        // ensure bbox is bounded by minimum and maximums
        if let latitude = pLatitude, let longitude = pLongitude {
            
            let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth  , Constants.Flickr.SearchLonRange.0)
            let minimumLat = max(latitude  - Constants.Flickr.SearchBBoxHalfHeight , Constants.Flickr.SearchLatRange.0)
            let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth  , Constants.Flickr.SearchLonRange.1)
            let maximumLat = min(latitude  + Constants.Flickr.SearchBBoxHalfHeight , Constants.Flickr.SearchLatRange.1)
            
            return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
        } else {
            return "0,0,0,0"
        }
    }
}
