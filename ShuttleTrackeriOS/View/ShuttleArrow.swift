//
//  ShuttleArrow.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/13/19.
//  Copyright ¬© 2019 WTG. All rights reserved.
//

import Foundation
import MapKit
import UIKit


/**
 Class responsible for overriding the default MapKit
 annotation of the red pin
 
 Uses a UIImage that is declared in the Shuttle object
 Rotates the image usingn the "heading" field
 Increases the size of the image slightly
 
 
 */
class ShuttleArrow:MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        
        
        
        willSet {
            guard let shuttle = newValue as? Shuttle else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            //adjust later for color/rotation
            var tempImage = UIImage(named: shuttle.imageName!)
            
            //fix this
            tempImage = tempImage!.rotate(radians: Float(Float(shuttle.heading-45) * Float(Float.pi/180)))
            tempImage = tempImage!.imageWithSize(size: CGSize(width: tempImage!.size.width * 1.5, height: tempImage!.size.height * 1.5))
            image = tempImage
        }
    }
}
