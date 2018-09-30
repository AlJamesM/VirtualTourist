//
//  CLLocationCoordinate2D+Extensions.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/21/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation
import MapKit

//Extend to be able to use CLLocationCoordinate2D as a dictionary key
extension CLLocationCoordinate2D: Hashable {
    public var hashValue: Int {
        return "\(latitude) \(longitude)".hashValue
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
