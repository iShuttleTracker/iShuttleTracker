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
    var vehicleIcons: [Int:CustomPointAnnotation] = [:]
    var timer = Timer()
    
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
        displayStops(stops: stops)
        grabVehicles(vehicles: vehicles)
        //scheduledTimerWithTimeInterval()
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
        westline.color = UIColor(red: 200/255, green: 55/255, blue: 0, alpha: 1)
        let eastline = CustomPolyline(coordinates: eastCoordinates, count: UInt(eastCoordinates.count))
        eastline.color = UIColor(red: 120/255, green: 180/255, blue: 0, alpha: 1)
        mapView.addAnnotation(westline)
        mapView.addAnnotation(eastline)
    }
    
    // Display stops
    func displayStops(stops: [Stop]){
        var count = 0
        for stop in stops{
            count += 1
            let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            let point = CustomPointAnnotation(coordinate: coordinate, title: stop.name, subtitle: stop.desc)
            point.reuseIdentifier = "customAnnotation\(count)"
            //point.image = dot(size:15, color: UIColor(red: 20/255, green: 80/255, blue: 200/255, alpha: 1))
            point.image = dot(size:15, color: UIColor.darkGray)
            mapView.addAnnotation(point)
        }
    }
    
    // 1. core animation
    // 2. Add annotation and remove it
    // 3. Icon
    // 4. Mapbox MGLayer
    // leaflet
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateVehicles), userInfo: nil, repeats: true)
    }
    
    @objc func updateVehicles(){
        //changeCoord()
    }
    
    func changeCoord(){
        UIView.animate(withDuration: 1.5, animations: {
            //self.point.coordinate = CLLocationCoordinate2D(latitude: 42.73028, longitude: -73.67736+Double(self.count))
        })
    }
    
    func grabVehicles(vehicles: [Vehicle]){
        var count = 0
        for vehicle in vehicles{
            count += 1
            let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            let point = CustomPointAnnotation(coordinate: coordinate, title: vehicle.tracker_id, subtitle: vehicle.description)
            point.image = dot(size:15, color: UIColor.orange)
            vehicleIcons[vehicle.id] = point
            mapView.addAnnotation(point)
        }
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
        eastCoordinates = parsedRoutes["East Campus"]!
        westCoordinates = parsedRoutes["West Campus"]!
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
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let point = annotation as? CustomPointAnnotation,
            let image = point.image,
            let reuseIdentifier = point.reuseIdentifier {
            
            if let annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier) {
                return annotationImage
            } else {
                return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
            }
        }
        
        return nil
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 4.5
    }

}
