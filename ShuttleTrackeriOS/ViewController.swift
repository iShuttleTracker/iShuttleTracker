//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import WebKit
import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MGLMapView!
    
    // Get shuttle tracker info
    let vehicles = initVehicles()
    let updates = initUpdates()
    let stops = initStops()
    let routes = initRoutes()
    
    // Store info
    var eastCoordinates: [CLLocationCoordinate2D]!
    var westCoordinates: [CLLocationCoordinate2D]!
    var lateNightCoordinates: [CLLocationCoordinate2D]!
    var parsedRoutes: [String:[CLLocationCoordinate2D]] = [:]
    
    // Display
    var eastline: CustomPolyline!
    var westline: CustomPolyline!
    
    //testing
    var source: MGLShapeSource!
    var contourLayer: [String: MGLStyleLayer?] = [:]
    
    //var timer = Timer()
    //var vehicleIcons: [String:CustomPointAnnotation] = [:]
    
    
    @IBAction func toggleRoutes(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showRoute(name: "east")
            showRoute(name: "west")
        case 1:
            showRoute(name: "east")
            hideRoute(name: "west")
        case 2:
            showRoute(name: "west")
            hideRoute(name: "east")
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        getInfo()
        
        //        let marker = MGLPointAnnotation();
        //        marker.coordinate=CLLocationCoordinate2D(latitude: 42.7302, longitude: -73.6788);
        //        marker.title="testing";
        //        mapView.addAnnotation(marker);
        
        //        var timer = Timer();
        //        timer.invalidate();
        //        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateURL), userInfo: nil, repeats: true)
        
        
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle){
        
        
        //get the updates at the time
        var updates = initUpdates()
        
        //for all the vehicles
        for i in 0...updates.count-1{
            
            //create a coordinate object
            let temp_coords = CLLocationCoordinate2D(latitude:updates[i].latitude,longitude:updates[i].longitude);
            
            //create a MGLShape
            let p = MGLPointAnnotation();
            p.coordinate=temp_coords;
            
            //MGLShapeSource with the annotation
            source = MGLShapeSource(identifier: String(updates[i].id), shape: p, options: nil);
            
            //add the point to the style layer
            style.addSource(source)
            
            //attach a picture to the point
            let picture = MGLSymbolStyleLayer(identifier:String(updates[i].id),source:source);
            picture.iconImageName=NSExpression(forConstantValue: "bus-15");
            style.addLayer(picture);
            
        }
        
        
        let eastColor = UIColor(red: 120/255, green: 180/255, blue: 0, alpha: 1)
        let westColor = UIColor(red: 200/255, green: 55/255, blue: 0, alpha: 1)
        
        displayRoute(to: style, name: "east", coordinates: eastCoordinates, color: eastColor)
        displayRoute(to: style, name: "west", coordinates: westCoordinates, color: westColor)
        //displayRoute(to: style, name: "lateNight", coordinates: lateNightCoordinates, color: UIColor.purple)
        
        displayStops(stops: stops)
        
        //create a timer to auto refresh
        var timer = Timer();
        
        //TODO
        //put on separate thread?
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updatePositions), userInfo: nil, repeats: true)
        
        
    }
    
    //    @objc func updateURL(){
    //        source.url=source.url;
    //    }
    // Wait until the map is loaded before adding to the map.
    
    // Display routes
    func displayRoute(to style: MGLStyle, name: String, coordinates: [CLLocationCoordinate2D], color: UIColor){
        let route = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        let routeSource = MGLShapeSource(identifier: name, shape: route, options: nil)
        let layer = MGLLineStyleLayer(identifier: name, source: routeSource)
        
        layer.sourceLayerIdentifier = name
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: color)
        layer.lineWidth = NSExpression(forConstantValue: 3.0)
        
        style.addSource(routeSource)
        style.addLayer(layer)
        
        self.contourLayer[name] = layer
        showRoute(name: name)
    }
    
    func showRoute(name: String){
        self.contourLayer[name]??.isVisible = true
    }
    
    func hideRoute(name: String){
        self.contourLayer[name]??.isVisible = false
    }
    
    // Display stops
    func displayStops(stops: [Stop]){
        var count = 0
        for stop in stops{
            count += 1
            let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            let point = CustomPointAnnotation(coordinate: coordinate, title: stop.name, subtitle: stop.desc)
            point.reuseIdentifier = "customAnnotation\(count)"
            point.image = dot(size:15, color: UIColor.darkGray)
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
        lateNightCoordinates = parsedRoutes["Weekend/Late Night"]!
    }
    
    func getInfo(){
        print("Initialized \(vehicles.count) vehicles")
        print("Initialized \(updates.count) updates")
        print("Initialized \(stops.count) stops")
        print("Initialized \(routes.count) routes")
        
        parsingData(routes: routes)
    }
    
    

    
    //repeted function calls to update vehicles on layer
    @objc func updatePositions(){
        
        //TODO
        //CLEAR style LAYERS?
        //THREAD FAULT BECAUSE OVERWRITING LAYER ALREADY THERE?
        
        
//        let style = mapView.style!;
//        print("THE LAYERS")
//        print(style.layers)
//        //get the updates at the time
//        var updates = initUpdates()
//
//        //for all the vehicles
//        for i in 0...updates.count-1{
//
//            //create a coordinate object
//            let temp_coords = CLLocationCoordinate2D(latitude:updates[i].latitude,longitude:updates[i].longitude);
//
//            //create a MGLShape
//            let p = MGLPointAnnotation();
//            p.coordinate=temp_coords;
//
//            //MGLShapeSource with the annotation
//            source = MGLShapeSource(identifier: String(updates[i].id), shape: p, options: nil);
//
//            //add the point to the style layer
//            style.addSource(source)
//
//            //attach a picture to the point
//            let picture = MGLSymbolStyleLayer(identifier:String(updates[i].id),source:source);
//            picture.iconImageName=NSExpression(forConstantValue: "bus-15");
//            style.addLayer(picture);
//
//        }
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
