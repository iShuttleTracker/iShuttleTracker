//
//  SettingsTableViewController.swift
//  iShuttleTracker
//
//  Created by Norbu Sonam on 9/24/19.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    
    @IBOutlet weak var eastCampusSwitch: UISwitch!
    @IBOutlet weak var westCampusSwitch: UISwitch!
    let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "map") as! ViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        eastCampusSwitch.setOn(true, animated: false)
        westCampusSwitch.setOn(true, animated: false)
    }
    
    /**
    Called when the east route switch is toggled on or off from the settings panel
    - Parameter routeSwitch: The switch after being toggled
    */
    @IBAction func eastCampusSwitchPressed(_ sender: Any) {
        if !eastCampusSwitch.isOn {
            for routeView in routeViews.values {
                if routeView.getName() == "East Campus" {
                    //routeView.disable(to: mapViewController.mapView)
                    return
                }
            }
        } else {
            for routeView in routeViews.values {
                if routeView.getName() == "East Campus" {
                    //routeView.display(to: mapViewController.mapView)
                    return
                }
            }
        }
    }
    
    /**
    Called when the west route switch is toggled on or off from the settings panel
    - Parameter routeSwitch: The switch after being toggled
    */
    @IBAction func westCampusSwitchPressed(_ sender: Any) {
        if !westCampusSwitch.isOn {
            for routeView in routeViews.values {
                if routeView.getName() == "West Campus" {
                    //routeView.disable(to: mapViewController.mapView)
                    return
                }
            }
        } else {
            for routeView in routeViews.values {
                if routeView.getName() == "West Campus" {
                    //routeView.display(to: mapViewController.mapView)
                    return
                }
            }
        }
    }
    

}
