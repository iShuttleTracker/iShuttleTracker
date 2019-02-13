//
//  RouteView.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/12/19.
//  Copyright © 2019 WTG. All rights reserved.
//
import MapKit

var routeViews:[String:RouteView] = [:]

class RouteView {
    var name: String?
    var id: Int
    var isEnabled: Bool
    var routePolyLine: MKPolyline?
    var stopAnnotations: [MKAnnotation]?
    
    init(name: String, id: Int, isEnabled: Bool){
        self.name = name
        self.id = id
        self.isEnabled = isEnabled
    }
    
    func createRoute(polyline: MKPolyline){
        self.routePolyLine = polyline
    }
    
    func createStop(){
        
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
        let polyline = MKPolyline(coordinates: &locations, count: locations.count)
        
        let newRoute = RouteView(name: route.name, id: id, isEnabled: route.enabled)
        newRoute.createRoute(polyline: polyline)
        routeViews[route.name] = newRoute
    }
}
