//
//  Location+Extensions.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/19/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation
import CoreData

extension Location {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
        currentPage = 1
        pageLimit   = 1
    }
}
