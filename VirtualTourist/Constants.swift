//
//  Constants.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/19/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Settings {
        static let ModelName         = "VirtualTourist"
        static let LongPressDuration = 1.0
        static let PhotoCount        = 15
        static let BlankImageName    = "camera"
        static let PinSound: UInt32  = 1057 // Pin System Sound
        static let MaxPages          = 100
    }
    
    struct Messages {
        static let NoPhotos   = "No photos on this location"
        static let Searching  = "Searching Photos ..."
        static let Empty      = ""
    }
    
    struct Map {
        static let PinReuseID = "PinFixed"
        static let MainPinReuseID = "PinMain"
    }
    
    struct CollectionView {
        static let PhotosPerRow  : CGFloat = 3.0
        static let PhotoSpacing  : CGFloat = 0.0
        static let SectionInsets : UIEdgeInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
        static let CellReuseIdentifier = "PhotoCell"
        static let Gap : CGFloat = 0.5
    }
    
    struct Flickr {
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 0.25
        static let SearchBBoxHalfHeight = 0.25
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    struct FlickrParameterValues {
        static let SearchMethod = "flickr.photos.search"
        static let APIKey = "1e909e50e9b3778b814091d69c696412"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        static let PerPageCount = "\(Settings.PhotoCount)"
    }
    
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
    struct MapRegionKey {
        static let Latitude  = "RegionLatitude"
        static let Longitude = "RegionLongitude"
        static let LatitudeDelta  = "RegionLatitudeDelta"
        static let LongitudeDelta = "RegionLongitudeDelta"
        static let LaunchedBefore = "LaunchedBefore"
        static let SpanDelta      = 4.0
    }
    
    struct CoreData {
        static let CreationDate = "creationDate"
    }
}
