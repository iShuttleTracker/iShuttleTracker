//
//  ShuttleArrow.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/13/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class ShuttleArrow:MKAnnotationView {
    
    /**
     Class responsible for overriding the default MapKit
        annotation of the red pin
     
     Uses a UIImage that is declared in the Shuttle object
     Rotates the image usingn the "heading" field
     Increases the size of the image slightly
 
 
    */
    
    override var annotation: MKAnnotation? {
        
        willSet {
            guard let shuttle = newValue as? Shuttle else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            //adjust later for color/rotation
            image = UIImage(named: shuttle.imageName!)!
            
            
            //fix this
            image = image!.rotate(radians: Float(Float(shuttle.heading-45) * Float(Float.pi/180)))
            image = image!.imageWithSize(size: CGSize(width: image!.size.width * 1.5, height: image!.size.height * 1.5))
        }
    }
}
