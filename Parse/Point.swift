//
//  point.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation
import CoreLocation

struct Point: Equatable {

    var latitude: Double
    var longitude: Double
    
    /**
     Default constructor.
     - Returns: A new Point with default values
     */
    init?() {
        latitude = 0.0
        longitude = 0.0
    }
    
    /**
     Initializes a new Point from latitude and longitude values.
     - Returns: A new Point with the specified latitude and longitude
     */
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /**
     Initializes a new Point from an Update.
     - Returns: A new Point with the latitude and longitude values from the
     specified Update.
     */
    init(update: Update) {
        self.latitude = update.latitude
        self.longitude = update.longitude
    }
    
    /**
     Initializes a new Point from a CLLocationCoordinate2D.
     - Returns: A new Point with the latitude and longitude values from the
     specified CLLocationCoordinate2D.
     */
    init(coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
    
    /**
     Approximates the distance between two points.
     - Returns: The distance between two points, in meters.
     */
    func distanceFrom(p: Point) -> Double {
        let startLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let endLocation = CLLocation(latitude: p.latitude, longitude: p.longitude)
        return startLocation.distance(from: endLocation)
    }

}

extension Point:CustomStringConvertible {
    var description:String {
        return """
                 (latitude \(self.latitude), longitude \(self.longitude))\n
                 """
    }
}
