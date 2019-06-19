//
//  CustomTabBar.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 3/18/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }

}
