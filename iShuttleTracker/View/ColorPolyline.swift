//
//  CustomPolyline.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 2/13/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import UIKit
import MapKit

/**
 Wrapper around MKPolyline that allows polylines to be colored.
 */
class ColorPolyline: MKPolyline {
    var color: UIColor?
}
