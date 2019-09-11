//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright ¬© 2018 iShuttleTracker. All rights reserved.
//
import UIKit
import MapKit

import UserNotifications

var lastLocation: Point? = nil // The most up-to-date location we have of the user

// Set this to true to enable shuttle predictions. Currently for debugging purposes, should be manipulated
// through the settings panel in the future.
var predictPositions = false

// Set this to true to enable shuttle ETAs on stop annotation subtitles. Currently for debugging purposes,
// should be manipulated through the settings panel in the future once ETAs are more reliable.
var predictETAs = false

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // The map where all the info is displayed
    @IBOutlet var mapView: MKMapView!
    
    // Switches in the settings panel
    @IBOutlet var eastRouteSwitch: UISwitch! = UISwitch()
    @IBOutlet var westRouteSwitch: UISwitch! = UISwitch()
    @IBOutlet var nearbyNotificationsSwitch: UISwitch! = UISwitch()
    @IBOutlet var scheduledNotificationsSwitch: UISwitch! = UISwitch()
    
    // Keeps track of the user's location
    let locationManager = CLLocationManager()
    
    // Stores the names of the currently active routes
    var activeRouteNames: [String] = ["All routes"]
    
    // The current annotations shown on the map
    var currentAnnotations: [MKAnnotation] = []
    
    // Stores the last unique updates received, can be checked against the global updates to see if
    // annotations should be updated
    var recentUpdates: [Update] = []
    
    // The last time new updates were checked for (checked every 10 seconds)
    var lastUpdateTime: Date = Date()
    
    // The last time annotations were completely refreshed (refreshed every 5 minutes to remove any
    // expired annotations)
    var lastRefreshTime: Date = Date()
    
    // No idea what this is
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    /**
     Initializes the stops, routes, and vehicles and adds them to the map view
     */
    func initView() {
        initStops()
        initRoutes()
        initVehicles()
        
        for (_, route) in routeViews {
            route.display(to: mapView)
        }
        
        for stop in stopViews {
            mapView.addAnnotation(stop)
        }
        
        // Uses shuttle asset instead of default marker
        mapView.register(StopAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ShuttleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        updateShuttleAnnotations()
    }
    
    /**
     Initializes the timer that updates vehicle annotations and handles notifications
     */
    func initTimer() {
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }
    
    /**
     Initializes the stops, routes, vehicles, and updates from the datafeed, then initializes the route view,
     stop view, and initializes switches in the settings panel
     */
    func initData() {
        // Data
        initStops()
        initRoutes()
        initVehicles()
        initUpdates()
        
        propagateUpdates()
        
        // View
        initRouteViews()
        initStopViews()
        
        // Settings
        eastRouteSwitch.addTarget(self, action: #selector(eastRouteChanged), for: UIControl.Event.valueChanged)
        westRouteSwitch.addTarget(self, action: #selector(westRouteChanged), for: UIControl.Event.valueChanged)
        nearbyNotificationsSwitch.addTarget(self, action: #selector(nearbyNotificationsChanged), for: UIControl.Event.valueChanged)
        scheduledNotificationsSwitch.addTarget(self, action: #selector(scheduledNotificationsChanged), for: UIControl.Event.valueChanged)
        
        refreshEnabledRoutes()
    }
    
    /**
     Initializes the map view
     */
    func initMapView() {
        // Set the origin of the map with relation to the currently active routes,
        // should be around (42.731228, -73.675352)
        let initialLocation = calculateCenterLocation()
        let regionRadius: CLLocationDistance = 2200
        
        func initMap(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.isRotateEnabled = false
            mapView.delegate = self
            mapView.mapType = .mutedStandard
            // Do these even work?
            mapView.showsUserLocation = true
            mapView.showsBuildings = false
            mapView.showsCompass = false
            mapView.showsTraffic = false
            mapView.showsPointsOfInterest = false
        }
        
        initMap(location: initialLocation)
    }
    
    func calculateCenterLocation() -> CLLocation {
        var minLatitude = 90.0
        var maxLatitude = -90.0
        
        var minLongitude = 180.0
        var maxLongitude = -180.0
        
        for (_, route) in routes {
            if route.enabled {
                for point in route.points {
                    if point.latitude < minLatitude {
                        minLatitude = point.latitude
                    }
                    if point.latitude > maxLatitude {
                        maxLatitude = point.latitude
                    }
                    if point.longitude < minLongitude {
                        minLongitude = point.longitude
                    }
                    if point.longitude > maxLongitude {
                        maxLongitude = point.longitude
                    }
                }
            }
        }
        let centerLatitude = (minLatitude + maxLatitude) / 2
        let centerLongitude = (minLongitude + maxLongitude) / 2
        return CLLocation(latitude: centerLatitude, longitude: centerLongitude)
    }
    
    func initAnnotations() {
        for (_, route) in routeViews {
            route.display(to: mapView)
        }
        
        for stop in stopViews {
            mapView.addAnnotation(stop)
        }
        
        updateShuttleAnnotations()
    }
    
    func registerViews() {
        // Uses shuttle asset instead of default marker
        mapView.register(ShuttleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    /**
     Adds each enabled route to the items list
     */
    func refreshEnabledRoutes() {
        // TODO: Should items get emptied before new names are appended to it?
        for (name, route) in routeViews {
            if route.isEnabled {
                activeRouteNames.append(name)
            }
        }
    }
    
    /**
     Updates the existing annotations on the map or adds new ones corresponding to the current updates.
     */
    func updateShuttleAnnotations() {
        for update in updates {
            let shuttle = ShuttleAnnotation(vehicle_id: update.vehicle_id, title: vehicles[update.vehicle_id]!.name, update_time: update.time, coordinate: CLLocationCoordinate2D(latitude: update.latitude, longitude: update.longitude), heading: Int(update.getRotation()), route_id: update.route_id, estimation: false)
            updateAnnotation(shuttle: shuttle)
            recentUpdates.append(update)
        }
    }
    
    /**
     Estimates the current shuttle position based on how long it's been since the last update and the speed
     the shuttle was traveling at in that update, then updates the annotations on the map.
     */
    func estimate() {
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
                let deltaLongitude = (nextPoint.longitude - estimationPoint.longitude);
                let y = sin(deltaLongitude) * cos(nextPoint.latitude);
                let x = cos(estimationPoint.latitude) * sin(nextPoint.latitude) - sin(estimationPoint.latitude)
                    * cos(nextPoint.latitude) * cos(deltaLongitude)
                let headingRad = atan2(y, x)
                var headingDeg = Int(headingRad * 180 / .pi)
                headingDeg = (headingDeg + 360) % 360
                headingDeg = 360 - headingDeg
                let shuttle = ShuttleAnnotation(vehicle_id: id, title: vehicles[id]!.name, update_time: dateToString(date: Date()), coordinate: CLLocationCoordinate2D(latitude: estimationPoint.latitude, longitude: estimationPoint.longitude), heading: headingDeg, route_id: vehicle.last_update.route_id, estimation: true)
                updateAnnotation(shuttle: shuttle)
            }
        }
    }
    
    /**
     Updates the annotation on the map corresponding to the given shuttle, or adds a new annotation if none
     exist with the same vehicle ID.
     - Parameter shuttle: The shuttle to update on the map
     */
    func updateAnnotation(shuttle: ShuttleAnnotation) {
        for i in 0..<mapView.annotations.count {
            if let shuttleAnnotation = mapView.annotations[i] as? ShuttleAnnotation {
                if shuttleAnnotation.vehicle_id == shuttle.vehicle_id {
                    shuttleAnnotation.coordinate = shuttle.coordinate
                    shuttleAnnotation.heading = shuttle.heading
                    shuttleAnnotation.estimation = shuttle.estimation
                    return
                }
            }
        }
        mapView.addAnnotation(shuttle)
    }
    
    
    /**
     Called on a 1-second timer to update the shuttle annotations on the map. If there are
     no new updates and shuttle predictions are on, shuttle annotations will be updated with
     estimated positions.
     */
    @objc func update() {
        // Only check for new updates if shuttle prediction is turned off or it's been over 10 seconds since
        // the last check
        //print(lastUpdateTime.timeIntervalSinceNow)
        if !predictPositions || lastUpdateTime.timeIntervalSinceNow < -10 {
            initUpdates()
            lastUpdateTime = Date()
            if updates != recentUpdates {
                propagateUpdates()
                NotificationHandler.getInstance().handleNearbyNotifications()
                recentUpdates.removeAll()
                // Clear annotations every 5 minutes in order to remove expired ones
                if lastRefreshTime.timeIntervalSinceNow < -300 {
                    for annotation in mapView.annotations {
                        if annotation is ShuttleAnnotation {
                            mapView.removeAnnotation(annotation)
                        }
                    }
                }
                updateShuttleAnnotations()
            }
        } else {
            estimate()
        }
        NotificationHandler.getInstance().handleScheduledNotifications()
    }
    
    /**
     Upon first opening the app, requests access to the user's location when the app is in use
     */
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("Location access denied")
            // TODO: Notify the user that some notification features will not be available
            
        default:
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    
    /**
     Checks whether the user has authorized location usage, and if so, starts updating the user's location
     */
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information
            return
        }
        // Do not start services that aren't available
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available
            return
        }
        // Configure and start the service
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10.0  // In meters
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    /**
     Regularly updates lastLocation with the user's location
     - Parameters:
     - manager: The location manager object
     - locations: The list of locations that the user has been seen at
     */
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        lastLocation = Point(coordinate: locations.last!.coordinate)
    }
    
    /**
     Location updates are not allowed
     - Parameters:
     - manager: The location manager object
     - error: Potential error, typically indicating that location updates are not authorized
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
    }
    
    /**
     Called when the east route switch is toggled on or off from the settings panel
     - Parameter routeSwitch: The switch after being toggled
     */
    @IBAction func eastRouteChanged(routeSwitch: UISwitch) {
        if routeSwitch.isOn {
            print("Toggled east route on")
            //            showRoute(name: "east")
        } else {
            print("Toggled east route off")
            //            hideRoute(name: "east")
        }
    }
    
    /**
     Called when the west route switch is toggled on or off from the settings panel
     - Parameter routeSwitch: The switch after being toggled
     */
    @IBAction func westRouteChanged(routeSwitch: UISwitch) {
        if routeSwitch.isOn {
            print("Toggled west route on")
            //            showRoute(name: "west")
        } else {
            print("Toggled west route off")
            //            hideRoute(name: "west")
        }
    }
    
    /**
     Called when the nearby notifications switch is toggled on or off from the settings panel
     - Parameter notificationSwitch: The switch after being toggled
     */
    @IBAction func nearbyNotificationsChanged(notificationSwitch: UISwitch) {
        if notificationSwitch.isOn {
            print("Toggled nearby notifications on")
            // TODO: Toggling this switch on should make the "Nearby Notifications" section of the settings
            //       panel visible. It should be hidden if this switch is toggled off.
        } else {
            print("Toggled nearby notifications off")
            // TODO: Hide the "Nearby Notifications" section.
        }
    }
    
    /**
     Called when the scheduled notifications switch is toggled on or off from the settings panel
     - Parameter notificationSwitch: The switch after being toggled
     */
    @IBAction func scheduledNotificationsChanged(notificationSwitch: UISwitch) {
        if notificationSwitch.isOn {
            print("Toggled scheduled notifications on")
            // TODO: Toggling this switch on should make the "Scheduled Trip Notifications" section of the
            //       settings panel visible. It should be hidden if the switch is toggled off.
        } else {
            print("Toggled scheduled notifications off")
            // TODO: Hide the "Scheduled Trips" section.
        }
    }
    
    /**
     Called after the view loads to initialize the map view and data
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        initData()
        initTimer()
    }
    
    /**
     Called after the map view finishes loading to initialize the view and timer
     */
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        registerViews()
        initAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? ColorPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = CGFloat(routes[polyline.route_id!]!.width / 2)
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Don't want to show a custom image if the annotation is the user's location.
        guard annotation is StopAnnotation else {
            return nil
        }
        
        // Overwrite default stop icon
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "StopIcon")?.imageWithSize(size:CGSize(width: 10, height: 10))
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let coordinate = CLLocationCoordinate2DMake(mapView.region.center.latitude, mapView.region.center.longitude)
        var span = mapView.region.span
        if span.latitudeDelta > 0.043 { // Max area shown
            span = MKCoordinateSpan(latitudeDelta: 0.043, longitudeDelta: 0.043)
        }
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
    }
    
}
