//
//  StopView.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/14/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import UIKit
import MapKit

var stopViews: [StopAnnotation] = []

/**
 Represents stops on the map.
 */
class StopAnnotation: NSObject, MKAnnotation {
    
    var title: String? // The title of this stop
    var coordinate: CLLocationCoordinate2D // The stop's coordinate
    var identifier = "Stop"
    
    /**
     Initializes a stop view
     - Parameters:
       - title: The title of this stop
       - The stop's coordinate
     */
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
    
}


/**
 Initializes a stop view from each stop fetched from the datafeed
 */
func initStopViews() {
    for (_, stop) in stops {
        let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        stopViews.append(StopAnnotation(title: stop.name, coordinate: coordinate))
    }
}
