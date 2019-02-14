//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import UIKit
import MapKit

class ViewController : UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    
    //TODO:
    /*
 
        Use currentDisplay to save the currently displayed vehicles and move
        them slowly, instead of just relying on updates... more detailed
        description in the issues page
    */
//    var currentDisplay: [Shuttle] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        displayVehicles();
    }
    
    //initial call to get the first updates and display them
    func displayVehicles(){
        initStops();
        initRoutes();
        initVehicles();
        
        newUpdates();
        
        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(ViewController.repeated), userInfo: nil, repeats: true)

    }
    
    //add annotations to the view
    func newUpdates(){
        
        initUpdates()
        for update in updates {
            let shuttle = Shuttle(title: String(update.vehicle_id), locationName: update.description, discipline: " ", coordinate: CLLocationCoordinate2D(latitude: update.latitude, longitude: update.longitude))
            mapView.addAnnotation(shuttle)
        }
    }
    
    //the function for Timer to call
    //deletes all annotations
    //adds them back
    @objc func repeated(){
    
        mapView.removeAnnotations(mapView.annotations)
        newUpdates()
    }
    
    
    //get user's location
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    
    
    
    func initMapView(){
        //code to set origin of mapkit
        let initialLocation = CLLocation(latitude: 42.7302, longitude: -73.6788);
        let regionRadius:CLLocationDistance = 2000;
        
        
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
            //extra settings for the map
            //do they even work?
            mapView.showsUserLocation = true;
            mapView.showsBuildings = false;
            mapView.showsCompass = false;
            mapView.showsTraffic = false;
            mapView.showsPointsOfInterest = false;
        }
        centerMapOnLocation(location: initialLocation)
        
    }


}


extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
}


