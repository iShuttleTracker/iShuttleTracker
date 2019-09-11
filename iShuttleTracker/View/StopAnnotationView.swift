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
            guard let _ = newValue as? StopAnnotation else { return }
            canShowCallout = true
        }
    }
    
}
