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
    let heading: Int
    
    /**
     
     constructor for a shuttle object to be displayed on the map
     - Parameters: vehicle_id - unique vehicle ID
                    locationName - information to insert into pop up bubble
                    coordinate - where the marker should be
                    heading - amount to rotate the shuttle marker
     */
    init(vehicle_id: Int, locationName: String, coordinate: CLLocationCoordinate2D, heading: Int) {
        self.vehicle_id = vehicle_id
        self.title = shuttleNames[vehicle_id]
        self.route_id = 1
        self.vehicle_name = " "
        self.locationName = locationName
        self.coordinate = coordinate
        self.heading = heading
        
        super.init()
    }
    
    /**
     function needed to return the pop up bubble information
     */
    var subtitle: String? {
        return locationName
    }
    
    /**
     - TODO:
     Add to this method to support different colors of shuttles
     Or look into coloring the actual uiimage
     */
    var imageName: String? {
        return "Shuttle"
    }

    
    
    
    
}
