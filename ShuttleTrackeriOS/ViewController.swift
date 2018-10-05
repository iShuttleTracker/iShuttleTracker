//
//  ViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Andrew Qu on 9/18/18.
//  Copyright © 2018 WTG. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /* let url = URL(string: "mapbox://styles/mapbox/streets-v10")
           let mapView = MGLMapView(frame: view.bounds, styleURL: url)
           mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           mapView.setCenter(CLLocationCoordinate2D(latitude: 42.7302, longitude: -73.6788), zoomLevel: 9, animated: false)
           view.addSubview(mapView) */
        // TODO: Right place to be calling this?
        let vehicles = fetchVehicles()
        let updates = fetchUpdates()
        let stops = fetchStops()
        let routes = fetchRoutes()
    }

}
