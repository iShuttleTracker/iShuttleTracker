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
            guard let shuttle = newValue as? Shuttle else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            //adjust later for color/rotation
            image = UIImage(named: shuttle.imageName!)
            var ci = image?.ciImage
        }
    }
}
