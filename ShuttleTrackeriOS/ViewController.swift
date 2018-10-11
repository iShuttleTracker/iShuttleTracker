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

    let vehicles = initVehicles()
    let updates = initUpdates()
    let stops = initStops()
    let routes = initRoutes()
    
    // =================================================================
    // Probably put these variables in another file, but put them here for now
    var eastPolylineSource: MGLShapeSource?
    var westPolylineSource: MGLShapeSource?
    var eastCoordinates: [CLLocationCoordinate2D]!
    var westCoordinates: [CLLocationCoordinate2D]!
    var lateNightCoordinates: [CLLocationCoordinate2D]!
    var parsedRoutes: [String:[CLLocationCoordinate2D]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        print("Initialized \(vehicles.count) vehicles")
        print("Initialized \(updates.count) updates")
        print("Initialized \(stops.count) stops")
        print("Initialized \(routes.count) routes")
        
        parsedRoutes = parsingData(routes: routes)
        
        eastCoordinates = parsedRoutes["East Campus"]!
        westCoordinates = parsedRoutes["West Campus"]!
    }
    
    // Wait until the map is loaded before adding to the map.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        displayRoute(to: mapView.style!, UIColor.red)
        updateRouteWithCoordinates(coordinates: eastCoordinates)
        
        //displayRoute(to: mapView.style!, UIColor.green)
        //updateRouteWithCoordinates(coordinates: westCoordinates)
    }
    
    
    
    // =================================================================
    // Probably put these functions in another file, but put them here for now
    
    /*
     1. Default: shows west and east routes
     2. Add buttons: show west/east route
     3. Late night route
     */
    
    // Display routes
    func displayRoute(to style: MGLStyle, _ eastColor: UIColor){
        let source = MGLShapeSource(identifier: "polyline", shape: nil, options: nil)
        style.addSource(source)
        eastPolylineSource = source
        
        // Style the line.
        let layer = MGLLineStyleLayer(identifier: "polyline", source: source)
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: eastColor)
        
        // The line width should gradually increase based on the zoom level.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 5, 18: 20])
        style.addLayer(layer)
    }
    
    // Draw lines
    func updateRouteWithCoordinates(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        let polyline = MGLPolylineFeature(coordinates: &mutableCoordinates, count: UInt(mutableCoordinates.count))
        eastPolylineSource?.shape = polyline
        
    }
    
    // Parsing longitude and latitude of points into a list
    // TODO: Function should change the input into the form of [(x1, y1), (x2, y2)]
    func parsingData(routes: [Route]) -> [String:[CLLocationCoordinate2D]]{
        var routesDic: [String:[CLLocationCoordinate2D]] = [:]
        for route in routes{
            var pointArr: [CLLocationCoordinate2D] = []
            for point in route.points{
                pointArr.append(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
            }
            routesDic[route.name] = pointArr
        }
        return routesDic
    }

    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    // Display any points (shuttle stops, vehicles and current location)
    // TODO: Used default annotation, need to change it later
    func displayPoint(latitude: Float, longitude: Float, name: String){
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        point.title = "Name: \(name)"
        mapView.addAnnotation(point)
    }

}
