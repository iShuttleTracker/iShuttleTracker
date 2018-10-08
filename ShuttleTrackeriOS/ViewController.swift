//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController {

    @IBOutlet var mapView: MGLMapView!
    
    // =================================================================
    // Probably put these variables in another file, but put them here for now
    var timer: Timer?
    var polylineSource: MGLShapeSource?
    var currentIndex = 1
    var allCoordinates: [CLLocationCoordinate2D]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.styleURL = MGLStyle.lightStyleURL
        
        // TODO: Right place to be calling this?
        let vehicles = initVehicles()
        let updates = initUpdates()
        let stops = initStops()
        let routes = initRoutes()
        
        print("Initialized \(vehicles.count) vehicles")
        print("Initialized \(updates.count) updates")
        print("Initialized \(stops.count) stops")
        print("Initialized \(routes.count) routes")
        
        allCoordinates = coordinates()
    }
    
    
    // =================================================================
    // Probably put these functions in another file, but put them here for now
    
    // Display any points (shuttle stops, vehicles and current location)
    // TODO: Used default annotation, need to change it later
    func displayPoint(latitude: Float, longitude: Float, name: String){
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        point.title = "Name: \(name)"
        mapView.addAnnotation(point)
    }
    
    // Display routes
    func displayRoute(to style: MGLStyle){
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        polylineSource = source
        
        // Style the line.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: UIColor.red)
        
        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 5, 18: 20])
        style.addLayer(layer)
        
    }
    
    // Calls tick() function, animate route
    func animateRoute(){
        currentIndex = 1
        // Start a timer that will simulate adding points to routes.
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    // Calls updateRouteWithCoordinates
    @objc func tick() {
        if currentIndex > allCoordinates.count {
            timer?.invalidate()
            timer = nil
            return
        }
        
        // Create a subarray of locations up to the current index.
        let coordinates = Array(allCoordinates[0..<currentIndex])
        
        // Update our MGLShapeSource with the current locations.
        updateRouteWithCoordinates(coordinates: coordinates)
        
        currentIndex += 1
    }
    
    // Draw lines
    func updateRouteWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        
        // Updating the MGLShapeSource’s shape will have the map redraw our polyline with the current coordinates.
        polylineSource?.shape = polyline
    }
    
    // Change a list into CLLocationCooridinate2D
    // TODO: Input should be in the form of [(x1, y1), (x2, y2), ...]
    func coordinates() -> [CLLocationCoordinate2D] {
        
        return [(0,0)].map({CLLocationCoordinate2D(latitude: $0.1, longitude: $0.0)})
    }
    
    // Parsing longitude and latitude of points into a list
    // TODO: Function should change the input into the form of [(x1, y1), (x2, y2)]
    func parsingData(){
        
    }
    
    
    // Wait until the map is loaded before adding to the map.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        displayRoute(to: mapView.style!)
        animateRoute()
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
        

}
