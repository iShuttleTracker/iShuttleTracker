//
//  point.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

struct Point: Equatable {

    var latitude: Double
    var longitude: Double
    
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
     Approximates the distance between two points.
     - Returns: An approximation of the distance between two points, in feet.
     */
    func distanceFrom(p: Point) -> Double {
        let pi = 0.017453292519943295;    // pi / 180
        let a = 0.5 - cos((p.latitude - latitude) * pi)/2 +
            cos(latitude * pi) * cos(p.latitude * pi) *
            (1 - cos((p.longitude - longitude) * pi))/2;
        return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
    }

}

extension Point:CustomStringConvertible {
    var description:String {
        return """
                 (latitude \(self.latitude), longitude \(self.longitude))\n
                 """
    }
}
