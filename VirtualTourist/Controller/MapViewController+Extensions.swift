//
//  MapViewController+Extensions.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/21/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.Map.MainPinReuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.Map.MainPinReuseID)
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "ShowAlbumSegue", sender: view)
    }
    
    // Save map region/span after user change
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapRegion()
    }
    
    func populateVisitedLocations() {
        mapView.removeAnnotations(mapView.annotations) // Clear Existing Annotations
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        
        if let locations = try? dataController.viewContext.fetch(fetchRequest) {
            var annotations = [MKPointAnnotation]()
            for aLocation in locations {
                
                let coordinate = CLLocationCoordinate2D(latitude: aLocation.latitude, longitude: aLocation.longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                
                places[coordinate] = aLocation
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationController = segue.destination as? PhotoAlbumViewController, let annotationView = sender as? MKAnnotationView {
            if let coordinate = annotationView.annotation?.coordinate {
                destinationController.dataController = dataController
                destinationController.location       = places[coordinate]
            }
        }
    }
    
    public func saveMapRegion() {
        let mapRegion = mapView.region
        UserDefaults.standard.set(true, forKey: Constants.MapRegionKey.LaunchedBefore)
        UserDefaults.standard.set(mapRegion.center.latitude    , forKey: Constants.MapRegionKey.Latitude)
        UserDefaults.standard.set(mapRegion.center.longitude   , forKey: Constants.MapRegionKey.Longitude)
        UserDefaults.standard.set(mapRegion.span.latitudeDelta , forKey: Constants.MapRegionKey.LatitudeDelta)
        UserDefaults.standard.set(mapRegion.span.longitudeDelta, forKey: Constants.MapRegionKey.LongitudeDelta)
    }
    
    public func setMapRegion() {
        let latitude       = UserDefaults.standard.double(forKey: Constants.MapRegionKey.Latitude)
        let longitude      = UserDefaults.standard.double(forKey: Constants.MapRegionKey.Longitude)
        let latitudeDelta  = UserDefaults.standard.double(forKey: Constants.MapRegionKey.LatitudeDelta)
        let longitudeDelta = UserDefaults.standard.double(forKey: Constants.MapRegionKey.LongitudeDelta)
        
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
        
        mapView.region = region
    }
}
