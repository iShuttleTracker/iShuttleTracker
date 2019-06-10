//
//  Shuttle.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/12/19.
//  Copyright ¬© 2019 WTG. All rights reserved.
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
     Constructor for a shuttle object to be displayed on the map
     - Parameters:
       - vehicle_id: Unique vehicle ID
       - locationName: Information to display in the pop-up bubble
       - coordinate: Where the marker should be
       - heading: Amount to rotate the shuttle marker by
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
     Gets the pop-up bubble information
     - Returns: locationName
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
