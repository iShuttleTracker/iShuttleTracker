//
//  ShuttleArrow.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/13/19.
//  Copyright ¬© 2019 iShuttleTracker. All rights reserved.
//

import Foundation
import MapKit
import UIKit

/**
 Responsible for overriding the default MapKit annotation of the red pin.
 
 Uses a UIImage that is declared in the Shuttle object, rotates the heading field, increases the
 size of the image slightly, and sets the color to the route color
 */
class ShuttleAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let shuttle = newValue as? ShuttleAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            // Initialize, rotate, resize, and color the image
            var tempImage = UIImage(named: shuttle.imageName!)!
            tempImage = tempImage.rotate(radians: Float(Float(shuttle.heading - 45) * Float(Float.pi / 180)))!
            tempImage = tempImage.imageWithSize(size: CGSize(width: tempImage.size.width * 1.25, height: tempImage.size.height * 1.25))
            var color = "#cfcfcf"
            if (routes[shuttle.route_id] != nil) {
                color = routes[shuttle.route_id]!.color
            }
            tempImage = tempImage.imageWithColor(color1: UIColor(hexString: color))
            
            image = tempImage
        }
    }
    
}
