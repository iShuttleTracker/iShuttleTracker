//
//  Shuttle.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/12/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import MapKit

class Shuttle : NSObject, MKAnnotation {
    
    let title: String?
    let vehicle_id: Int
    let route_id: Int
    let vehicle_name: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(vehicle_id: Int, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.vehicle_id = vehicle_id
        self.title = shuttleNames[vehicle_id]
        self.route_id = 1
        self.vehicle_name = " "
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var imageName: String? {
        return "Shuttle"
    }

    
    
    
    
}
