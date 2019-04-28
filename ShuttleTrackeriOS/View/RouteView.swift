//
//  RouteView.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/12/19.
//  Copyright © 2019 WTG. All rights reserved.
//
import MapKit

var routeViews:[String:RouteView] = [:]

struct RouteView {
    private var name: String                        // "East Campus"
    private var id: Int                             // id is the int stored in route
    var routePolyLine: CustomPolyline?              // Store the polyline of current route
    private var color: UIColor                      // Color
    var isEnabled: Bool                             // Check if the route is displayed according to the web
    var isDisplaying: Bool = false                  // Check if the route is displaying based on user input
    //private var stopAnnotations: [MKAnnotation]?    // Store the corresponding stops

    init(name: String, id: Int, isEnabled: Bool, color: String){
        self.name = name
        self.id = id
        self.isEnabled = isEnabled
        self.color = UIColor(hexString: color)
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
        polyline.title = route.name
        var newRoute = RouteView(name: route.name, id: id, isEnabled: route.enabled, color: route.color)
        newRoute.routePolyLine = polyline
        newRoute.routePolyLine?.color = UIColor(hexString: route.color)
        routeViews[route.name] = newRoute
    }
}
