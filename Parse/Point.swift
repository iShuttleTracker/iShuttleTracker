//
//  point.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/26/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation

struct Point {

    var latitude: Double
    var longitude: Double
    
    /**
     Initializes a new Point.
     - Returns: A new Point with the specified latitude and longitude
     */
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

}

extension Point:CustomStringConvertible {
    var description:String {
        return """
                 (latitude \(self.latitude), longitude \(self.longitude))\n
                 """
    }
}
