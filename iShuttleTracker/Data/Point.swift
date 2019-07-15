//
//  point.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 iShuttleTracker. All rights reserved.
//

import Foundation
import CoreLocation

struct Point: Equatable, CustomStringConvertible {

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
     Initializes a new Point from a CLLocationCoordinate2D.
     - Returns: A new Point with the latitude and longitude values from the
     specified CLLocationCoordinate2D.
     */
    init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    /**
     Approximates the distance between two points.
     - Parameters:
       - latitude: The latitude of the point to get the distance from
       - longitude: The longitude of the point to get the distance from
     - Returns: The distance between this point and the given latitude and longitude.
     */
    func distanceFrom(latitude: Double, longitude: Double) -> Double {
        let startLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let endLocation = CLLocation(latitude: latitude, longitude: longitude)
        return startLocation.distance(from: endLocation)
    }
    
    /**
     Approximates the distance between two points.
     - Returns: The distance between two points, in meters.
     */
    func distanceFrom(p: Point) -> Double {
        return distanceFrom(latitude: p.latitude, longitude: p.longitude)
    }
    
    /**
     Checks if two points are equivalent.
     - Parameters:
       - lhs: The left hand side Point to compare
       - rhs: The right hand side Point to compare
     - Returns: True if the two points' latitude and longitude values are the same, false otherwise.
     */
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    var description: String {
        return """
        (latitude \(self.latitude), longitude \(self.longitude))\n
        """
    }

}
