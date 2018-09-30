//
//  PhotoAlbumViewController+Extensions.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/25/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit
import MapKit
import CoreData

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aPhoto = fetchedResultsController.object(at: indexPath)
        let cell   = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionView.CellReuseIdentifier, for: indexPath) as! PhotoCollectionViewCell

        cell.backgroundColor = UIColor.white
        cell.delegate        = self
        cell.photo           = aPhoto
        cell.buttonView.isHidden = !aPhoto.downloaded
        cell.waitingView.isHidden = aPhoto.downloaded
        aPhoto.downloaded ? cell.activityIndicator.stopAnimating() : cell.activityIndicator.startAnimating()
        
        if let image = aPhoto.image {
            cell.photoView.image = UIImage(data: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aPhoto = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(aPhoto)
        try? dataController.viewContext.save()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? PhotoViewController, let photo = sender as? Photo {
            destinationController.photo = photo
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// CollectionView Layout
extension PhotoAlbumViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / Constants.CollectionView.PhotosPerRow - 1
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.CollectionView.SectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.PhotoSpacing + Constants.CollectionView.Gap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionView.PhotoSpacing
    }
}

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
    }
}

extension PhotoAlbumViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.Map.PinReuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.Map.PinReuseID)
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}

extension PhotoAlbumViewController: PhotoCellDelegate {
    func deletePhoto(photo: Photo) {
        performSegue(withIdentifier: "ShowPhotoDetailSegue", sender: photo)
    }
}
