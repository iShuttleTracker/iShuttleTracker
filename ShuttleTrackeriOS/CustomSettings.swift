//
//  Polyline.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 10/11/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation
import Mapbox
// TODO: customize points
class CustomPointAnnotation: NSObject, MGLAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var reuseIdentifier: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}

// Customize polyline
class CustomPolyline: MGLPolyline {
    var color: UIColor?
}
