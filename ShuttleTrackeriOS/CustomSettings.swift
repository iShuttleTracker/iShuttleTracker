//
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 10/11/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import Foundation
import Mapbox

// Customize points
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

class CustomVehicleAnnotation: MGLPointAnnotation{
    
    func setCoord(coord: CLLocationCoordinate2D){
        self.coordinate = coord
    }
}

// Customize polyline
class CustomPolyline: MGLPolyline {
    var color: UIColor?
}

// Customize UIImage
func dot(size: Int, color: UIColor) -> UIImage {
    let floatSize = CGFloat(size)
    let rect = CGRect(x: 0, y: 0, width: floatSize, height: floatSize)
    let strokeWidth: CGFloat = 1
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
    
    let ovalPath = UIBezierPath(ovalIn: rect.insetBy(dx: strokeWidth, dy: strokeWidth))
    color.setFill()
    ovalPath.fill()
    
    UIColor.white.setStroke()
    ovalPath.lineWidth = strokeWidth
    ovalPath.stroke()
    
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
}
