//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/18/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {

    var location                 : Location!
    var dataController           : DataController!
    var fetchedResultsController : NSFetchedResultsController<Photo>!
    var trackCompletion = 0
    //var photos : [Photo]!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var messageBar: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        setupMapToAnnotationRegion()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }

    @IBAction func pressedNewCollection(_ sender: UIButton) {
        photoAlbumDownloadFromFlickr()
    }
    
    @IBAction func pressedDeleteAlbum(_ sender: UIBarButtonItem) {
        dataController.viewContext.delete(self.location)
        try? dataController.viewContext.save()
        navigationController?.popViewController(animated: true)
    }
    
    func displayAlert(title : String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

// Photo Album Creation Functions
extension PhotoAlbumViewController {
    func setupFetchedResultsController() {
        fetchedResultsController = NSFetchedResultsController(fetchRequest          : fetchRequestPhoto(),
                                                              managedObjectContext  : dataController.viewContext,
                                                              sectionNameKeyPath    : nil,
                                                              cacheName             : "album_\(location.latitude)_\(location.longitude)")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            if let photos = fetchedResultsController.fetchedObjects, photos.count == 0 {
                photoAlbumDownloadFromFlickr()
            } else {
                collectionView.reloadData()
            }
        } catch {
            fatalError("Fetch can't be performed: \(error.localizedDescription)")
        }
    }
    
    func photoAlbumDownloadFromFlickr() {
        
        enableUI(false)
        enableMessage(true, Constants.Messages.Searching )
        trackCompletion = 0
        
        photoAlbumDelete() // Clear Album First for new set of photos
        
        let curPage = Int(location.currentPage)
        let maxPage = Int(location.pageLimit)
        
        let page = curPage < maxPage ? (curPage + 1) : 1
        self.location.currentPage = Int16(page)
        
        NetworkClient.shared.getPhotos(latitude: self.location.latitude, longitude: self.location.longitude, page: page) { (photos, pages, error) in
            if error != nil {
                self.displayAlert(title: "Error", message: error!)
            } else {
                self.enableMessage(false, Constants.Messages.Empty)
                if let photosArray = photos, photosArray.count > 0 {
                    let pageLimit = min(pages, Constants.Settings.MaxPages)
                    self.location.pageLimit = Int16(pageLimit)
                    
                    self.photoAlbumLoad(photosArray)
                    
                } else {
                    self.enableMessage(true, Constants.Messages.NoPhotos)
                    self.enableUI(true)
                }
            }
        }
    }
    
    func setupMapToAnnotationRegion() {
        let annotation = MKPointAnnotation()
        
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let span       = MKCoordinateSpan(latitudeDelta: Constants.MapRegionKey.SpanDelta, longitudeDelta: Constants.MapRegionKey.SpanDelta)
        
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion.init(center: coordinate, span: span)
        mapView.region = region
    }
    
    func fetchRequestPhoto() -> NSFetchRequest<Photo> {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: Constants.CoreData.CreationDate, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let predicate = NSPredicate(format: "location == %@", location)
        fetchRequest.predicate = predicate
        
        return fetchRequest
    }
    
    func photoAlbumDelete() {
        if let result = try? dataController.viewContext.fetch(fetchRequestPhoto()) {
            for object in result {
                dataController.viewContext.delete(object)
            }
        }
    }
    
    func photoAlbumLoad(_ photosArray : [[String : AnyObject]]) {
        for photoDictionary in photosArray {
            if let imageUrlString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String {
                let imageURL = URL(string: imageUrlString)
                photoEntityCreateFromURL(imageURL, photosArray.count)
            }
        }
    }
    
    func photoEntityCreateFromURL(_ URL: URL?,_ count: Int) {
        let photo = Photo(context: self.dataController.viewContext) // Create Photo Object
        photo.location = location
        let task = URLSession.shared.dataTask(with: URL!) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    photo.downloaded = true
                    photo.image      = data!
                    do {
                        try self.dataController.viewContext.save()
                        self.checkCompleted(count)
                    } catch {
                        fatalError("Can't save context: \(error.localizedDescription)")
                    }
                }
            }
        }
        task.resume()
    }
    
    func enableUI(_ status: Bool) {
        newCollectionButton.isEnabled = status
    }
    
    func enableMessage(_ status: Bool, _ message: String) {
        messageBar.text     = message
        messageBar.isHidden = !status
    }
    
    // Re-enableUI when all expected photos are downloaded (or no photos found - for refresh), might need a timer later for this...
    func checkCompleted(_ count: Int) {
        trackCompletion += 1
        if trackCompletion >= count {
            enableUI(true)
        }
    }
}
