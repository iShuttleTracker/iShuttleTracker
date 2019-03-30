//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright ¬© 2018 WTG. All rights reserved.
//

import UIKit
import MapKit

import UserNotifications

var shuttleNames = [Int:String]()
var lastLocation: Point? = nil // The most up-to-date location we have of the user

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    // Settings
    @IBOutlet var eastRouteSwitch: UISwitch! = UISwitch()
    @IBOutlet var westRouteSwitch: UISwitch! = UISwitch()
    @IBOutlet var nearbyNotificationsSwitch: UISwitch! = UISwitch()
    @IBOutlet var scheduledNotificationsSwitch: UISwitch! = UISwitch()
    
    let locationManager = CLLocationManager()
    
    
    var items:[String] = ["All routes"]
    
    var currentUpdates:[MKAnnotation] = []
    
    var recentUpdates:[Update] = []
    
    var lastUpdateTime: Date = Date()
    
    
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    // Stops before routes, routes before updates, vehicles before updates
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
        
        // Settings
        eastRouteSwitch.addTarget(self, action: #selector(eastRouteChanged), for: UIControl.Event.valueChanged)
        westRouteSwitch.addTarget(self, action: #selector(westRouteChanged), for: UIControl.Event.valueChanged)
        nearbyNotificationsSwitch.addTarget(self, action: #selector(nearbyNotificationsChanged), for: UIControl.Event.valueChanged)
        scheduledNotificationsSwitch.addTarget(self, action: #selector(scheduledNotificationsChanged), for: UIControl.Event.valueChanged)
        
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
            //            showRoute(name: "east")
        } else {
            print("Toggled east route off")
            //            hideRoute(name: "east")
        }
    }
    
    @IBAction func westRouteChanged(westRouteSwitch: UISwitch) {
        if westRouteSwitch.isOn {
            print("Toggled west route on")
            //            showRoute(name: "west")
        } else {
            print("Toggled west route off")
            //            hideRoute(name: "west")
        }
    }
    
    @IBAction func nearbyNotificationsChanged(nearbyNotificationsSwitch: UISwitch) {
        if nearbyNotificationsSwitch.isOn {
            print("Toggled nearby notifications on")
            // TODO: Toggling this switch on should make the "Nearby Notifications" section of the settings
            //       panel visible. It should be hidden if this switch is toggled off.
        } else {
            print("Toggled nearby notifications off")
            // TODO: Hide the "Nearby Notifications" section.
        }
    }
    
    @IBAction func scheduledNotificationsChanged(scheduledNotificationsSwitch: UISwitch) {
        if scheduledNotificationsSwitch.isOn {
            print("Toggled scheduled notifications on")
            // TODO: Toggling this switch on should make the "Scheduled Trip Notifications" section of the
            //       settings panel visible. It should be hidden if the switch is toggled off.
        } else {
            print("Toggled scheduled notifications off")
            // TODO: Hide the "Scheduled Trips" section.
        }
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
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.repeated), userInfo: nil, repeats: true)
        
    }
    
    //add annotations to the view
    func newUpdates(){
        //display new updates
        for update in updates {
            let shuttle = Shuttle(vehicle_id: update.vehicle_id, locationName: update.time, coordinate: CLLocationCoordinate2D(latitude: update.latitude, longitude: update.longitude), heading: Int(update.heading))
            //mapView.addAnnotation(shuttle)
            updateAnnotation(shuttle: shuttle)
            //currentUpdates.append(shuttle)
        }
    }
    
    func estimate() {
        for (id, vehicle) in vehicles {
            // Only update this vehicle if it is on a valid route
            if vehicle.last_update.route.points.count > 0 {
                let estimation = vehicle.estimateCurrentPosition()
                // print("\(vehicle.id): \(estimation)")
                // TODO: fix heading
                let shuttle = Shuttle(vehicle_id: id, locationName: "Estimation", coordinate: CLLocationCoordinate2D(latitude: estimation.latitude, longitude: estimation.longitude), heading: 0)
                // mapView.addAnnotation(shuttle)
                updateAnnotation(shuttle: shuttle)
                //currentUpdates.append(shuttle)
            }
        }
    }
    
    func updateAnnotation(shuttle: Shuttle) {
        for i in 0..<mapView.annotations.count {
            if let shuttleAnnotation = mapView.annotations[i] as? Shuttle {
                if shuttleAnnotation.vehicle_id == shuttle.vehicle_id {
                    shuttleAnnotation.coordinate = shuttle.coordinate
                    return
                }
            }
        }
        mapView.addAnnotation(shuttle)
    }
    
    
    //the function for Timer to call
    //deletes all annotations
    //adds them back
    @objc func repeated(){
        //mapView.removeAnnotations(currentUpdates)
        currentUpdates.removeAll()
        
        // Check for updates every 10 seconds
        if lastUpdateTime.timeIntervalSinceNow < -10 {
            //fetch latest /updates feed
            initUpdates()
            lastUpdateTime = Date()
            newUpdates()
        } else {
            estimate()
        }
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
