//
//  PhotoViewController.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/26/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit
import CoreData

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let imageData = photo.image {
            imageView.image = UIImage(data: imageData)
        }
    }
}
