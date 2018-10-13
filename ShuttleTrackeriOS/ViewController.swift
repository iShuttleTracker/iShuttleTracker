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
        
        displayStops(stops: stops)
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
    
    // Display stops
    func displayStops(stops: [Stop]){
        var count = 0
        for stop in stops{
            count += 1
            let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            let point = CustomPointAnnotation(coordinate: coordinate, title: stop.name, subtitle: stop.desc)
            point.reuseIdentifier = "customAnnotation\(count)"
            point.image = dot(size:15)
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
    }
    
    // Customize UIImage
    func dot(size: Int) -> UIImage {
        let floatSize = CGFloat(size)
        let rect = CGRect(x: 0, y: 0, width: floatSize, height: floatSize)
        let strokeWidth: CGFloat = 1
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        let ovalPath = UIBezierPath(ovalIn: rect.insetBy(dx: strokeWidth, dy: strokeWidth))
        UIColor.darkGray.setFill()
        ovalPath.fill()
        
        UIColor.white.setStroke()
        ovalPath.lineWidth = strokeWidth
        ovalPath.stroke()
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
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

}
