//
//  RouteView.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/12/19.
//  Copyright © 2019 WTG. All rights reserved.
//
import MapKit

var routeViews:[String:RouteView] = [:]
var color:[String:UIColor] = [
    "East Campus" : UIColor(red: 120/255, green: 180/255, blue: 0, alpha: 1),
    "West Campus" : UIColor(red: 200/255, green: 55/255, blue: 0, alpha: 1),
    "Weekend/Late Night" : UIColor.purple,
    "East Inclement Weather Route" : UIColor.brown,
    "West Inclement Weather Route" : UIColor.darkGray
]

class RouteView {
    var name: String
    var id: Int
    var isEnabled: Bool
    var routePolyLine: CustomPolyline?
    var stopAnnotations: [MKAnnotation]?
    
    init(name: String, id: Int, isEnabled: Bool){
        self.name = name
        self.id = id
        self.isEnabled = isEnabled
    }
    
    func createRoute(polyline: CustomPolyline){
        self.routePolyLine = polyline
        if let routeColor = color[name] {
            self.routePolyLine?.color = routeColor
        }
    }
    
    func createStop(){
        
    }
    
    // The initial display function
    func display(to mapView: MKMapView){
        
    }
    
    // Toggling routes function
    func enable(to mapView: MKMapView){
        
    }
    
    func disable(to mapView: MKMapView){
        mapView.removeAnnotations(stopAnnotations!)
        mapView.removeOverlay(routePolyLine!)
    }
}

func initRouteView(){
    for (id, route) in routes {
        if let _ = routeViews[route.name] {
            continue
        }
        var locations: [CLLocationCoordinate2D] = []
        for point in route.points{
            locations.append(CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude))
        }
        let polyline = CustomPolyline(coordinates: &locations, count: locations.count)
        let newRoute = RouteView(name: route.name, id: id, isEnabled: route.enabled)
        newRoute.createRoute(polyline: polyline)
        routeViews[route.name] = newRoute
    }
}
