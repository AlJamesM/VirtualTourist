//
//  PhotoCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/21/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate: AnyObject {
    func deletePhoto(photo: Photo)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PhotoCellDelegate?
    var photo : Photo!
    
    @IBOutlet weak var waitingView : UIView!
    @IBOutlet weak var buttonView  : UIView!
    @IBOutlet weak var photoView   : UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func deletePressed(_ sender: UIButton) {
        delegate?.deletePhoto(photo: photo)
    }
}
