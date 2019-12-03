//
//  SettingsTableViewController.swift
//  iShuttleTracker
//
//  Created by Norbu Sonam on 9/24/19.
//

import UIKit

var hiddenRoutes = Set<Int>()

class SettingsTableViewController: UITableViewController {

    // Route Views
    @IBOutlet weak var westCampusView: UIView!
    @IBOutlet weak var eastCampusView: UIView!
    @IBOutlet weak var weekendLateNightView: UIView!
    @IBOutlet weak var eastWeatherView: UIView!
    @IBOutlet weak var westWeatherView: UIView!
    
    // Switches
    @IBOutlet weak var eastCampusSwitch: UISwitch!
    @IBOutlet weak var westCampusSwitch: UISwitch!
    @IBOutlet weak var weekendLateNightSwitch: UISwitch!
    @IBOutlet weak var eastWeatherSwitch: UISwitch!
    @IBOutlet weak var westWeatherSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initButtons()
    }
    
    func initButtons() {
        for route in routeViews.values {
            if !route.isEnabled {
                switch route.getId() {
                case 1:
                    westCampusView.isHidden = true
                case 3:
                    weekendLateNightView.isHidden = true
                case 4:
                    eastWeatherView.isHidden = true
                case 5:
                    westWeatherView.isHidden = true
                case 15:
                    eastCampusView.isHidden = true
                default:
                    continue
                }
            }
        }
    }
    
    func routeSwitchPressed(uiSwitch: UISwitch, id: Int) {
        
        if !uiSwitch.isOn {
            for routeView in routeViews.values {
                if routeView.getId() == id {
                    hiddenRoutes.insert(id)
                    print("hide")
                    return
                }
            }
        } else {
            for routeView in routeViews.values {
                if routeView.getId() == id {
                    hiddenRoutes.remove(id)
                    print("show")
                    return
               }
            }
        }
        
    }
    
    @IBAction func eastCampusSwitchPressed(_ sender: Any) {
        routeSwitchPressed(uiSwitch: eastCampusSwitch, id: 15)
    }
    
    @IBAction func westCampusSwitchPressed(_ sender: Any) {
        routeSwitchPressed(uiSwitch: westCampusSwitch, id: 1)
    }
    
    @IBAction func weekendLateNightSwitchPressed(_ sender: Any) {
        routeSwitchPressed(uiSwitch: weekendLateNightSwitch, id: 3)
    }
    @IBAction func eastWeatherSwitchPressed(_ sender: Any) {
        routeSwitchPressed(uiSwitch: eastWeatherSwitch, id: 4)
    }
    @IBAction func westWeatherSwitchPressed(_ sender: Any) {
        routeSwitchPressed(uiSwitch: westWeatherSwitch, id: 5)
    }
}
