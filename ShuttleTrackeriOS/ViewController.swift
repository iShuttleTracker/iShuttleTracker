//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    
    // =================================================================
    // Probably put these variables in another file, but put them here for now
    var eastCoordinates: [CLLocationCoordinate2D]!
    var westCoordinates: [CLLocationCoordinate2D]!
    var lateNightCoordinates: [CLLocationCoordinate2D]!
    var parsedRoutes: [String:[CLLocationCoordinate2D]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let vehicles = initVehicles()
        let updates = initUpdates()
        let stops = initStops()
        let routes = initRoutes()
        
        print("Initialized \(vehicles.count) vehicles")
        print("Initialized \(updates.count) updates")
        print("Initialized \(stops.count) stops")
        print("Initialized \(routes.count) routes")
        
        parsingData(routes: routes)
        
        eastCoordinates = parsedRoutes["East Campus"]!
        westCoordinates = parsedRoutes["West Campus"]!
    }
    
    // Wait until the map is loaded before adding to the map.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        displayRoute()
    }
    
    
    // =================================================================
    // Probably put these functions in another file, but put them here for now

    
    // Display routes
    func displayRoute(){
        let westline = CustomPolyline(coordinates: westCoordinates, count: UInt(westCoordinates.count))
        westline.color = UIColor.red
        let eastline = CustomPolyline(coordinates: eastCoordinates, count: UInt(eastCoordinates.count))
        eastline.color = UIColor.green
        mapView.addAnnotation(westline)
        mapView.addAnnotation(eastline)
    }

    // Parsing longitude and latitude of points into a list
    func parsingData(routes: [Route]){
        for route in routes{
            var pointArr: [CLLocationCoordinate2D] = []
            for point in route.points{
                pointArr.append(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
            }
            parsedRoutes[route.name] = pointArr
        }
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        if let annotation = annotation as? CustomPolyline {
            return annotation.color ?? .purple
        }
        return mapView.tintColor
    }

    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func displayPoint(latitude: Float, longitude: Float, name: String){
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        point.title = "Name: \(name)"
        mapView.addAnnotation(point)
    }

}
