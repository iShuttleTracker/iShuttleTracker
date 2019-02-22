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
        addSegementedControl()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? CustomPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = polyline.color
            renderer.lineWidth = 5
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        
        return annotationView
    }
}



