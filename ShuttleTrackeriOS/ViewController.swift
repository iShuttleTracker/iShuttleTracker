//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    
    func displayRoutes(){
        for (_, route) in routeViews {
            route.display(to: mapView)
        }
    }
    
    func displayStops(){
        for stop in stopViews {
            mapView.addAnnotation(stop)
        }
    }
    
    func initData(){
        // Data
        initStops()
        initRoutes()
        initVehicles()
        initUpdates()
        
        // View
        initRouteView()
        initStopView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        initData()
    }
}

extension ViewController: MKMapViewDelegate {
    
    func initMapView(){
        let center = CLLocationCoordinate2D(latitude: 42.7302, longitude: -73.6788)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 800, longitudinalMeters: 800)
        
        mapView.delegate = self
        mapView.centerCoordinate = center
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: false)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        displayRoutes()
        displayStops()
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
        // Don't want to show a custom image if the annotation is the user's location.
        guard !(annotation is StopView) else {
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
            annotationView.image = UIImage(named: "circle")
        }
        
        return annotationView
    }
    
}



