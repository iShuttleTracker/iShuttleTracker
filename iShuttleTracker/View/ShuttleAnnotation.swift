//
//  Shuttle.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/12/19.
//  Copyright ¬© 2019 iShuttleTracker. All rights reserved.
//

import Foundation
import MapKit

/**
 Represents a shuttle marker on the map.
 */
class ShuttleAnnotation : NSObject, MKAnnotation {
    
    let title: String?
    let vehicle_id: Int
    let route_id: Int
    let vehicle_name: String?
    let locationName: String
    @objc dynamic var heading: Int
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    /**
     Constructor for a shuttle object to be displayed on the map
     - Parameters:
       - vehicle_id: Unique vehicle ID
       - locationName: Information to display in the pop-up bubble
       - coordinate: Where the marker should be
       - heading: Amount to rotate the shuttle marker by
     */
    init(vehicle_id: Int, title: String, locationName: String, coordinate: CLLocationCoordinate2D, heading: Int, route_id: Int) {
        self.vehicle_id = vehicle_id
        self.title = title
        self.route_id = route_id
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
