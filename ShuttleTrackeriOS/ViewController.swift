//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import UIKit
import MapKit

// UISegmentedControl: list of string objects
//      - Check enabled routes
//      - Add names accordingly
//      - Enable corresponding routes
var shuttleNames = [Int:String]()

class ViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    
    var items:[String] = ["All routes"]
    
    
    func displayRoutes(){
        for (_, route) in routeViews {
            route.display(to: mapView)
        }
    }
    
    func displayStops(){
        for stop in stopViews {
            mapView.addAnnotation(stop)
        }
    }
    
    // It is based on index changed
    // Click on one segment twice????
    @objc func indexChanged(_ sender: UISegmentedControl) {
        let routeName = items[sender.selectedSegmentIndex]
        if let route = routeViews[routeName] {
            if route.isDisplaying{
                route.disable(to: mapView)
            } else {
                route.enable(to: mapView)
            }
        }
    }
    
    func checkEnabledRoutes(){
        for (name, route) in routeViews {
            if route.isEnabled {
                items.append(name)
            }
        }
    }
    
    func initData(){
        // Data
        initStops()
        initRoutes()
        initVehicles()
        initUpdates()
        
        // View
        initRouteView()
        initStopView()
        
        checkEnabledRoutes()
    }
  
    func initMapView(){
        //code to set origin of mapkit
        let initialLocation = CLLocation(latitude: 42.7302, longitude: -73.6788);
        let regionRadius:CLLocationDistance = 2000;
        
        
        func initMap(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
            mapView.isRotateEnabled = false;
            
            mapView.delegate = self;
            //sets map to be minimalistic
            mapView.mapType = .mutedStandard
            //extra settings for the map
            //do they even work?
            mapView.showsUserLocation = true;
            mapView.showsBuildings = false;
            mapView.showsCompass = false;
            mapView.showsTraffic = false;
            mapView.showsPointsOfInterest = false;
        }
        initMap(location: initialLocation)
    }
       //initial call to get the first updates and display them
    func displayVehicles(){
        initStops();
        initRoutes();
        initVehicles();
        for vehicle in vehicles{
            shuttleNames[vehicle.value.id] = vehicle.value.name;
        }
        
        //uses shuttle asset instead of default marker
        mapView.register(ShuttleArrow.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        newUpdates();
        
        //crash resposible because repeated without parameters
        _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(ViewController.repeated), userInfo: nil, repeats: true)
        
    }
    //add annotations to the view
    func newUpdates(){
        
        initUpdates()
        for update in updates {
            let shuttle = Shuttle(vehicle_id: update.vehicle_id, locationName: update.time, coordinate: CLLocationCoordinate2D(latitude: update.latitude, longitude: update.longitude))
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
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        initData()
//        displayVehicles()
    }
}

//extension ViewController: MKMapViewDelegate {

    
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        // Don't want to show a custom image if the annotation is the user's location.
//        guard !(annotation is StopView) else {
//            return nil
//        }
//
//        // Better to make this class property
//        let annotationIdentifier = "AnnotationIdentifier"
//
//        var annotationView: MKAnnotationView?
//        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
//            annotationView = dequeuedAnnotationView
//            annotationView?.annotation = annotation
//        }
//        else {
//            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
//            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            annotationView = av
//        }
//
//        if let annotationView = annotationView {
//            annotationView.canShowCallout = true
//            annotationView.image = UIImage(named: "circle")
//
//
//        return annotationView
//    }
//    }
//}

