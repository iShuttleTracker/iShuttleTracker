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
    
    // Used to keep track of the user's most recent location
    let locationManager = CLLocationManager()
    
    // Set this to false to disable shuttle predictions. Currently for debugging purposes only, but should
    // be manipulated through the settings panel in the future.
    var predictPositions = false
    
    // Stores all the currently enabled routes
    var items: [String] = ["All routes"]
    
    // Stores the last unique updates received, can be checked against the global updates to see if
    // annotations should be updated
    var recentUpdates: [Update] = []
    
    // The last time new updates were checked for (checked every 10 seconds)
    var lastUpdateTime: Date = Date()
    
    // The last time annotations were completely refreshed (refreshed every 5 minutes to remove any
    // expired annotations)
    var lastRefreshTime: Date = Date()
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    var last_estimations: [Int:Point] = [:]
    
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
        propagateUpdates()
        
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
        initStops()
        initRoutes()
        initVehicles()
        for vehicle in vehicles {
            shuttleNames[vehicle.value.id] = vehicle.value.name;
        }
        
        //uses shuttle asset instead of default marker
        mapView.register(ShuttleArrow.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        newUpdates();
        
        //crash resposible because repeated without parameters
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.repeated), userInfo: nil, repeats: true)
        
    }
    
    /**
     Updates the existing annotations on the map or adds new ones corresponding to the current updates.
     */
    func newUpdates(){
        for update in updates {
            let shuttle = Shuttle(vehicle_id: update.vehicle_id, locationName: update.time, coordinate: CLLocationCoordinate2D(latitude: update.latitude, longitude: update.longitude), heading: Int(update.heading))
            updateAnnotation(shuttle: shuttle)
            recentUpdates.append(update)
            
            let distance = last_estimations[update.vehicle_id]!.distanceFrom(p: update.point)
            print("Last estimation for vehicle \(update.vehicle_id) was \(distance) off")
        }
    }
    
    /**
     Estimates the current shuttle position based on how long it's been since the last update and the speed
     the shuttle was traveling at in that update, then updates the annotations on the map.
     */
    func estimate() {
        var updated_estimations: [Int] = []
        for (id, vehicle) in vehicles {
            // Only update this vehicle if it is on a valid route
            if vehicle.last_update.route.points.count > 0 {
                let estimationIndex = vehicle.estimateCurrentPosition()
                var nextIndex = estimationIndex + 1
                if nextIndex >= vehicle.last_update.route.points.count {
                    nextIndex = 0
                }
                // TODO: fix heading, doesn't seem to be calculated correctly
                let estimationPoint = vehicle.last_update.route.points[estimationIndex]
                let nextPoint = vehicle.last_update.route.points[nextIndex]
                let deltaLongitude = (nextPoint.longitude - estimationPoint.longitude)
                let y = sin(deltaLongitude) * cos(nextPoint.latitude)
                let x = cos(estimationPoint.latitude) * sin(nextPoint.latitude) - sin(estimationPoint.latitude)
                    * cos(nextPoint.latitude) * cos(deltaLongitude)
                let headingRad = atan2(y, x)
                var headingDeg = Int(headingRad * 180 / .pi)
                headingDeg = (headingDeg + 360) % 360
                headingDeg = 360 - headingDeg
                let shuttle = Shuttle(vehicle_id: id, locationName: "Estimation", coordinate: CLLocationCoordinate2D(latitude: estimationPoint.latitude, longitude: estimationPoint.longitude), heading: headingDeg)
                updateAnnotation(shuttle: shuttle)
                last_estimations[vehicle.id] = estimationPoint
                updated_estimations.append(vehicle.id)
            }
        }
        for (id, location) in last_estimations {
            if !updated_estimations.contains(id) {
                last_estimations.removeValue(forKey: id)
            }
        }
    }
    
    /**
     Updates the annotation on the map corresponding to the given shuttle, or adds a new annotation if none
     exist with the same vehicle ID.
     - Parameter shuttle: The shuttle to update on the map
     */
    func updateAnnotation(shuttle: Shuttle) {
        for i in 0..<mapView.annotations.count {
            if let shuttleAnnotation = mapView.annotations[i] as? Shuttle {
                if shuttleAnnotation.vehicle_id == shuttle.vehicle_id {
                    shuttleAnnotation.coordinate = shuttle.coordinate
                    shuttleAnnotation.heading = shuttle.heading
                    return
                }
            }
        }
        mapView.addAnnotation(shuttle)
    }
    
    
    /**
     Called on a 1-second timer to either initialize updates or estimate shuttle positions then update
     the annotations on the map.
     */
    @objc func repeated(){
        // Only check for new updates if shuttle prediction is turned off or it's been over 10 seconds since
        // the last check
        //print(lastUpdateTime.timeIntervalSinceNow)
        if !predictPositions || lastUpdateTime.timeIntervalSinceNow < -10 {
            initUpdates()
            lastUpdateTime = Date()
            if updates != recentUpdates {
                propagateUpdates()
                tryNotifyTime()
                tryNotifyNearby()
                recentUpdates.removeAll()
                // Clear annotations every 5 minutes in order to remove expired ones
                if lastRefreshTime.timeIntervalSinceNow < -300 {
                    for annotation in mapView.annotations {
                        mapView.removeAnnotation(annotation)
                    }
                }
                newUpdates()
            }
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
