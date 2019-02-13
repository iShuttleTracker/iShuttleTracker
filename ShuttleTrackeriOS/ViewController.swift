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
            if route.isEnabled{
                mapView.addOverlay(route.routePolyLine!)
            }
        }
    }
    
    func initData(){
        initStops()
        initRoutes()
        initVehicles()
        initUpdates()
        initRouteView()
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
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 4
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
}



