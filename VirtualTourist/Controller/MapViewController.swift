//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Al Manigsaca on 9/18/18.
//  Copyright © 2018 Al Manigsaca. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import AVFoundation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    var dataController: DataController!
    var places = [CLLocationCoordinate2D:Location].init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addGestureRecognizer(setLongPressedGR())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Full Screen MapView
        self.navigationController?.isNavigationBarHidden = true
        
        // Set map region to previously saved region/span if it does not exists
        if UserDefaults.standard.bool(forKey: Constants.MapRegionKey.LaunchedBefore) { setMapRegion() }
        
        populateVisitedLocations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func addAnnotation(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addLocation(coordinate: coordinate)
        }
    }
    
    func addLocation(coordinate: CLLocationCoordinate2D) {
        let location = Location(context: dataController.viewContext)
        location.latitude  = Double(coordinate.latitude)
        location.longitude = Double(coordinate.longitude)
        location.photos    = nil
        
        do {
            try dataController.viewContext.save()
            
            let annotation        = MKPointAnnotation()
            annotation.coordinate = coordinate
            places[coordinate]    = location
            
            mapView.addAnnotation(annotation)
            AudioServicesPlaySystemSound(Constants.Settings.PinSound) // Play system sound when pin appears
            
        } catch {
            fatalError("Can't save context: \(error.localizedDescription)")
        }
    }
    
    func setLongPressedGR() -> UILongPressGestureRecognizer {
        let longPressGR =  UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        longPressGR.minimumPressDuration = Constants.Settings.LongPressDuration
        longPressGR.numberOfTouchesRequired = 1
        return longPressGR
    }
}
