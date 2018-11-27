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
    // Check whether a route has been added
    var addedRoutes: [String:CustomPolyline] = [:]
    
    //var timer = Timer()
    //var vehicleIcons: [String:CustomPointAnnotation] = [:]
    
    
    @IBAction func toggleRoutes(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            addRoutes(addRoute: "east")
            addRoutes(addRoute: "west")
        case 1:
            addRoutes(addRoute: "east")
            removeRoutes(removeRoute: "west")
        case 2:
            addRoutes(addRoute: "west")
            removeRoutes(removeRoute: "east")
        default:
            break
        }
    }
    
    func removeRoutes(removeRoute: String){
        if let route = addedRoutes[removeRoute] {
            mapView.removeAnnotation(route)
            addedRoutes.removeValue(forKey: removeRoute)
        }
    }
    
    func addRoutes(addRoute: String){
        if let _ = addedRoutes[addRoute]{
            
        } else {
            if addRoute == "east"{
                mapView.addAnnotation(eastline)
                addedRoutes["east"] = eastline
            } else if addRoute == "west"{
                mapView.addAnnotation(westline)
                addedRoutes["west"] = westline
            }
        }
    }
    
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
        
        parsingData(routes: routes)
        
        
        
        //        let marker = MGLPointAnnotation();
        //        marker.coordinate=CLLocationCoordinate2D(latitude: 42.7302, longitude: -73.6788);
        //        marker.title="testing";
        //        mapView.addAnnotation(marker);
        
        //        var timer = Timer();
        //        timer.invalidate();
        //        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateURL), userInfo: nil, repeats: true)
        
        
    }
    //    @objc func updateURL(){
    //        source.url=source.url;
    //    }
    // Wait until the map is loaded before adding to the map.
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        displayRoute()
        displayStops(stops: stops)
    }
    
    
    
    // Display routes
    func displayRoute(){
        westline = CustomPolyline(coordinates: westCoordinates, count: UInt(westCoordinates.count))
        westline.color = UIColor(red: 200/255, green: 55/255, blue: 0, alpha: 1)
        eastline = CustomPolyline(coordinates: eastCoordinates, count: UInt(eastCoordinates.count))
        eastline.color = UIColor(red: 120/255, green: 180/255, blue: 0, alpha: 1)
        mapView.addAnnotation(westline)
        mapView.addAnnotation(eastline)
        addedRoutes["east"] = eastline
        addedRoutes["west"] = westline
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
        
        //create a timer to auto refresh
        var timer = Timer();
        
        //TODO
        //put on separate thread?
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updatePositions), userInfo: nil, repeats: true)
            
        
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
    
    // 1. core animation
    // 2. Add annotation and remove it
    // 3. Icon
    // 4. Mapbox MGLayer
    // leaflet
    //    func scheduledTimerWithTimeInterval(){
    //        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.updateVehicles), userInfo: nil, repeats: true)
    //    }
    
    //    @objc func updateVehicles(){
    //        //changeCoord()
    //        let updates = initUpdates()
    //        for update in updates{
    //            if let a = vehicleIcons[update.tracker_id]{
    //                print("Prev: \(a.coordinate)")
    //                a.coordinate = CLLocationCoordinate2D(latitude: update.latitude, longitude: update.longitude)
    //                print("Post: \(a.coordinate)")
    //            }
    //        }
    //
    //
    //    }
    
    //    func changeCoord(){
    //        UIView.animate(withDuration: 1.5, animations: {
    //            //self.point.coordinate = CLLocationCoordinate2D(latitude: 42.73028, longitude: -73.67736+Double(self.count))
    //        })
    //    }
    
    //    func grabVehicles(vehicles: [Vehicle]){
    //        var count = 0
    //        for vehicle in vehicles{
    //            count += 1
    //            let coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    //            let point = CustomPointAnnotation(coordinate: coordinate, title: vehicle.tracker_id, subtitle: vehicle.description)
    //            point.image = dot(size:15, color: UIColor.orange)
    //            vehicleIcons[vehicle.tracker_id] = point
    //            mapView.addAnnotation(point)
    //        }
    //    }
    
    
}
