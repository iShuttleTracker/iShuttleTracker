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
import UserNotifications

var lastLocation: Point? = nil // The most up-to-date location we have of the user

class ViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MGLMapView!
    
    // Settings
    @IBOutlet var eastRouteSwitch: UISwitch! = UISwitch()
    @IBOutlet var westRouteSwitch: UISwitch! = UISwitch()
    @IBOutlet var nearbyNotificationsSwitch: UISwitch! = UISwitch()
    @IBOutlet var scheduledNotificationsSwitch: UISwitch! = UISwitch()
    
    let locationManager = CLLocationManager()
    
    // Store info
    var eastCoordinates: [CLLocationCoordinate2D]!
    var westCoordinates: [CLLocationCoordinate2D]!
    var lateNightCoordinates: [CLLocationCoordinate2D]!
    var parsedRoutes: [String:[CLLocationCoordinate2D]] = [:]
    
    //testing
    var source: MGLShapeSource!
    var routeLayer: [String: MGLStyleLayer?] = [:]
    
    var updateTimer = Timer()
    //var vehicleIcons: [String:CustomPointAnnotation] = [:]
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startReceivingLocationChanges()
        
        mapView.styleURL = MGLStyle.lightStyleURL
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        // Stops before routes, routes before updates, vehicles before updates
        initStops()
        initRoutes()
        initVehicles()
        initUpdates()
        
        parsingData()
        
        //        let marker = MGLPointAnnotation();
        //        marker.coordinate=CLLocationCoordinate2D(latitude: 42.7302, longitude: -73.6788);
        //        marker.title="testing";
        //        mapView.addAnnotation(marker);
        
        //        var timer = Timer();
        //        timer.invalidate();
        updateTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        
        // Settings
        eastRouteSwitch.addTarget(self, action: #selector(eastRouteChanged), for: UIControl.Event.valueChanged)
        westRouteSwitch.addTarget(self, action: #selector(westRouteChanged), for: UIControl.Event.valueChanged)
        nearbyNotificationsSwitch.addTarget(self, action: #selector(nearbyNotificationsChanged), for: UIControl.Event.valueChanged)
        scheduledNotificationsSwitch.addTarget(self, action: #selector(scheduledNotificationsChanged), for: UIControl.Event.valueChanged)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle){
        
        displayStops()
        
        let eastColor = UIColor(red: 120/255, green: 180/255, blue: 0, alpha: 1)
        let westColor = UIColor(red: 200/255, green: 55/255, blue: 0, alpha: 1)
        
        initRoute(to: style, name: "east", coordinates: eastCoordinates, color: eastColor)
        initRoute(to: style, name: "west", coordinates: westCoordinates, color: westColor)
        initRoute(to: style, name: "lateNight", coordinates: lateNightCoordinates, color: UIColor.purple)
        
        displayRoutes()
        
        //for all the vehicles
        for update in updates {
            
            //create a coordinate object
            let temp_coords = CLLocationCoordinate2D(latitude:update.latitude,longitude:update.longitude);
            
            //create a MGLShape
            let p = MGLPointAnnotation();
            p.coordinate=temp_coords;
            
            //MGLShapeSource with the annotation
            source = MGLShapeSource(identifier: String(update.id), shape: p, options: nil);
            
            //add the point to the style layer
            style.addSource(source)
            
            //attach a picture to the point
            let picture = MGLSymbolStyleLayer(identifier:String(update.id),source:source);
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
    
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        lastLocation = Point(coordinate: locations.last!.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // TODO: Notify the user that some features will not be available
    }
    
    @objc func update() {
        initUpdates()
        
        // Try to send any notifications
        tryNotifyTime()
        tryNotifyNearby()
    }
    
    //    @objc func updateURL(){
    //        source.url=source.url;
    //    }
    
    @IBAction func eastRouteChanged(eastRouteSwitch: UISwitch) {
        if eastRouteSwitch.isOn {
            print("Toggled east route on")
            showRoute(name: "east")
        } else {
            print("Toggled east route off")
            hideRoute(name: "east")
        }
    }
    
    @IBAction func westRouteChanged(westRouteSwitch: UISwitch) {
        if westRouteSwitch.isOn {
            print("Toggled west route on")
            showRoute(name: "west")
        } else {
            print("Toggled west route off")
            hideRoute(name: "west")
        }
    }
    
    @IBAction func nearbyNotificationsChanged(nearbyNotificationsSwitch: UISwitch) {
        if nearbyNotificationsSwitch.isOn {
            print("Toggled nearby notifications on")
            // TODO
        } else {
            print("Toggled nearby notifications off")
            // TODO
        }
    }
    
    @IBAction func scheduledNotificationsChanged(scheduledNotificationsSwitch: UISwitch) {
        if scheduledNotificationsSwitch.isOn {
            print("Toggled scheduled notifications on")
            // TODO
        } else {
            print("Toggled scheduled notifications off")
            // TODO
        }
    }
    
    func displayRoutes(){
        showRoute(name: "east")
        showRoute(name: "west")
        
        // TODO: Show or Hide lateNight based on time
        hideRoute(name: "lateNight")
    }
    
    func initRoute(to style: MGLStyle, name: String, coordinates: [CLLocationCoordinate2D], color: UIColor){
        let route = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        let routeSource = MGLShapeSource(identifier: name, shape: route, options: nil)
        let layer = MGLLineStyleLayer(identifier: name, source: routeSource)
        
        layer.sourceLayerIdentifier = name
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        layer.lineColor = NSExpression(forConstantValue: color)
        layer.lineWidth = NSExpression(forConstantValue: 4.5)
        
        style.addSource(routeSource)
        style.addLayer(layer)
        
        self.routeLayer[name] = layer
    }
    
    func showRoute(name: String){
        if let _ = routeLayer[name]{
            self.routeLayer[name]??.isVisible = true
        }
    }
    
    func hideRoute(name: String){
        if let _ = routeLayer[name]{
            self.routeLayer[name]??.isVisible = false
        }
    }
    
    // Display stops
    func displayStops(){
        var count = 0
        for (id, stop) in stops{
            count += 1
            let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            let point = CustomPointAnnotation(coordinate: coordinate, title: stop.name, subtitle: stop.desc)
            point.reuseIdentifier = "customAnnotation\(count)"
            point.image = dot(size:15, color: UIColor.darkGray)
            mapView.addAnnotation(point)
        }
    }
    
    // Parsing longitude and latitude of points into a list
    func parsingData(){
        for (id, route) in routes{
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
