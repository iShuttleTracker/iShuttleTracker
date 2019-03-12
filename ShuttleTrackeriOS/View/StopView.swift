//
//  StopView.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/14/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import UIKit
import MapKit

var stopViews:[StopView] = []

class StopView: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var identifier = "Stop"
    
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
}


// Display stops
func initStopView(){
    for (_, stop) in stops {
        let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        stopViews.append(StopView(title: stop.name, coordinate: coordinate))
    }
}
