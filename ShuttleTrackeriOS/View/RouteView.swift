//
//  RouteView.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/12/19.
//  Copyright © 2019 WTG. All rights reserved.
//
import MapKit

var routeViews: [String:RouteView] = [:]

class RouteView {
    
    private var name: String // The route name, i.e. "East Campus"
    private var id: Int // The unique route ID
    private var routePolyLine: CustomPolyline? // The polyline of the current route
    private var stopAnnotations: [MKAnnotation]? // The annotations of the stops on this route
    private var color: UIColor // The color of the route as it is displayed on the map
    var isEnabled: Bool // Whether or not the route is enabled or not, according to the datafeed
    var isDisplaying: Bool = false // Whether or not the route should be displayed based on user input
    

    /**
     Initializes the route view
     - Parameters:
       - name: Name of the route
       - id: The route ID
       - isEnabled: Whether or not the route is enabled
       - color: The color of the route in hexadecimal
    */
    init(name: String, id: Int, isEnabled: Bool, color: String){
        self.name = name
        self.id = id
        self.isEnabled = isEnabled
        self.color = UIColor(hexString: color)
    }
    
    /**
     - Returns: The route name
     */
    func getName() -> String {
        return name
    }
    
    /**
     - Returns: The route ID
     */
    func getId() -> Int {
        return id
    }
    
    /**
     Sets the route polyline
     - Parameter polyline: The polyline
     */
    func createRoute(polyline: CustomPolyline){
        self.routePolyLine = polyline
        polyline.color = color

    }
    
    /**
     Displays this route's polyline on the map
     - Parameter mapView: The map view to display on
     */
    func display(to mapView: MKMapView) {
        if isEnabled {
            mapView.addOverlay(routePolyLine!)
            isDisplaying = true
        }
    }
    
    /**
     Toggle the route display on
     - Parameter mapView: The map view this route is on
     */
    func enable(to mapView: MKMapView){
        isDisplaying = true
        mapView.addOverlay(routePolyLine!)
    }
    
    /**
     Toggle the route display off
     - Parameter mapView: The map view this route is on
     */
    func disable(to mapView: MKMapView) {
        //mapView.removeAnnotations(stopAnnotations!)
        isDisplaying = false
        mapView.removeOverlay(routePolyLine!)
    }
    
}

/**
 Initializes a route view from each route fetched from the datafeed
 */
func initRouteViews() {
    for (id, route) in routes {
        if let _ = routeViews[route.name] {
            continue
        }
        var locations: [CLLocationCoordinate2D] = []
        for point in route.points{
            locations.append(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
        }
        let polyline = CustomPolyline(coordinates: &locations, count: locations.count)
        let newRoute = RouteView(name: route.name, id: id, isEnabled: route.enabled, color: route.color)
        newRoute.createRoute(polyline: polyline)
        routeViews[route.name] = newRoute
    }
}
