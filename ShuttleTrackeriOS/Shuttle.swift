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
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var imageName: String? {
        if discipline == "Sculpture" { return "Statue" }
        return "Flag"
    }

    
    
    
    
}
