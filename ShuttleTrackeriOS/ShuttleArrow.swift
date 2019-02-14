//
//  ShuttleArrow.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/13/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import MapKit

class ShuttleArrow:MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let artwork = newValue as? Shuttle else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            if let imageName = artwork.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
        }
    }
}
