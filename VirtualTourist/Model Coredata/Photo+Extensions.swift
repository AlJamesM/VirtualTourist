//
//  Photo+Extensions.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/21/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension Photo {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
        downloaded   = false
        if let blankImage = UIImage(named: Constants.Settings.BlankImageName) {
            image = UIImagePNGRepresentation(blankImage)
        }
    }
}
