//
//  CustomTabBar.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 3/18/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import UIKit

/**
 Wrapper around UITabBarController that sets the default index in a standard three-entry
 tab bar to the middle element.
 */
class CenteredTabBar: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }

}
