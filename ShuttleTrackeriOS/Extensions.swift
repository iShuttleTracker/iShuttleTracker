//
//  Extensions.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 2/15/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {

    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        displayVehicles()
        displayRoutes()
        displayStops()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? CustomPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = 2
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        /**
         
         Overwrite the default stop behavior by using a custom asset
 
         */
        // Don't want to show a custom image if the annotation is the user's location.
        guard annotation is StopView else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "StopIcon")?.imageWithSize(size: CGSize(width: 10, height: 10))
        }
        
        
        return annotationView
    }


}

// Resize the given image
extension UIImage {
    
        
        func imageWithSize(size:CGSize) -> UIImage
        {
            var scaledImageRect = CGRect.zero;
            
            let aspectWidth:CGFloat = size.width / self.size.width;
            let aspectHeight:CGFloat = size.height / self.size.height;
            let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);
            
            scaledImageRect.size.width = self.size.width * aspectRatio;
            scaledImageRect.size.height = self.size.height * aspectRatio;
            scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
            scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0);
            
            self.draw(in: scaledImageRect);
            
            let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return scaledImage!;
        }
        
        func rotate(radians: Float) -> UIImage? {
            var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
            // Trim off the extremely small float value to prevent core graphics from rounding it up
            newSize.width = floor(newSize.width)
            newSize.height = floor(newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
            let context = UIGraphicsGetCurrentContext()!
            
            // Move origin to middle
            context.translateBy(x: newSize.width/2, y: newSize.height/2)
            // Rotate around middle
            context.rotate(by: CGFloat(radians))
            // Draw the image at its center
            self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
}

// Convert hex string into UIColor
extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
