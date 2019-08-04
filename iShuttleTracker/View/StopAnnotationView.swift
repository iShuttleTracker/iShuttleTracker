//
//  StopAnnotationView.swift
//  iShuttleTracker
//
//  Created by Matt Czyr on 8/4/19.
//

import Foundation
import MapKit

class StopAnnotationView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let stop = newValue as? StopAnnotation else { return }
            canShowCallout = true
            /*calloutOffset = CGPoint(x: -5, y: 5)
             rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
             
             // Initialize, rotate, resize, and color the image
             var tempImage = UIImage(named: shuttle.imageName!)!
             tempImage = tempImage.rotate(radians: Float(Float(shuttle.heading - 45) * Float(Float.pi / 180)))!
             tempImage = tempImage.imageWithSize(size: CGSize(width: tempImage.size.width * 1.5, height: tempImage.size.height * 1.5))
             var color = "#cfcfcf"
             if (routes[shuttle.route_id] != nil) {
             color = routes[shuttle.route_id]!.color
             }
             tempImage = tempImage.imageWithColor(color1: UIColor(hexString: color))
             
             image = tempImage*/
        }
    }
    
}
