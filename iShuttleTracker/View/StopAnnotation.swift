//
//  StopView.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/14/19.
//  Copyright © 2019 iShuttleTracker. All rights reserved.
//

import UIKit
import MapKit

var stopViews: [StopAnnotation] = []

/**
 Represents stops on the map.
 */
class StopAnnotation: NSObject, MKAnnotation {
    
    var stop_id: Int // The ID of this stop
    var title: String? // The title of this stop
    var coordinate: CLLocationCoordinate2D // The stop's coordinate
    var identifier = "Stop"
    
    /**
     Initializes a stop view
     - Parameters:
     - title: The title of this stop
     - The stop's coordinate
     */
    init(stop: Stop) {
        self.stop_id = stop.id
        self.title = stop.name
        self.coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        super.init()
    }
    
    /**
     Gets the pop-up bubble information
     - Returns: locationName
     */
    var subtitle: String? {
        var sub = "boiugvikv"
        for (_, route) in routes {
            if route.enabled {
                // TODO: Change this to look at schedule data instead of calculating
                //       seconds for each shuttle
                var lowestETA = -1.0
                for (_, vehicle) in vehicles {
                    if vehicle.last_update.route.hasStop(stop_id: stop_id) {
                        let secondsAway = vehicle.secondsUntilReachesStop(stop: stops[stop_id]!)
                        if secondsAway < lowestETA || lowestETA == -1.0 {
                            lowestETA = secondsAway
                        }
                    }
                }
                if lowestETA > -1.0 {
                    sub += "\(route.name) ETA: \(Int(lowestETA)) seconds\n"
                }
            }
        }
        return sub
    }
    
}

/**
 Initializes a stop view from each stop fetched from the datafeed
 */
func initStopViews() {
    for (_, stop) in stops {
        stopViews.append(StopAnnotation(stop: stop))
    }
}
