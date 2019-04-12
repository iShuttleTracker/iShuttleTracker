//
//  CustomTableViewController.swift
//  ShuttleTrackeriOS
//
//  Created by Beiqi Zou on 3/20/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    // TODO: Need to add an update function which is constantly called
    //      in order to get route name updates
    
    private var sections = ["ROUTES", "NOTIFICATIONS", "NEARBY NOTIFICATIONS", "SCHEDULED TRIP NOTIFICATIONS"]
    
    private var route_cell:[String] = []
    private var notification_cell = ["Enable Nearby Notifications", "Enable Scheduled Notifications"]
    private var nearbyNotification_cell:[String] = []
    private var scheduledNotification_cell:[String] = []
    private var section_cell:[[String]] = []
    
    // TODO: Need to call this function every time when the route list gets updated
    func updateRouteCell() {
        route_cell.removeAll()
        for one_route in routeViews {
            if one_route.value.isEnabled{
                route_cell.append(one_route.key)
            }
        }
    }
    
    func updateNearbyNotificationCell() {
        nearbyNotification_cell.removeAll()
        for one_route in routeViews {
            if one_route.value.isEnabled{
                nearbyNotification_cell.append("Notify for " + one_route.key)
            }
        }
    }
    
    func update(){
        updateRouteCell()
        updateNearbyNotificationCell()
        section_cell = [route_cell, notification_cell, nearbyNotification_cell, scheduledNotification_cell]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    // TODO: Each section has different number of cells
    //      Dynamically assign these cell names
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section_cell[section].count
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        //routeViews[route_cell[sender.tag]]?.isDisplaying = sender.isOn
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = indexPath.section
        if sections[currentSection] == "SCHEDULED TRIP NOTIFICATIONS" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSchedule", for: indexPath)
            cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Switches", for: indexPath)
            
            //here is programatically switch make to the table view
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(false, animated: true)
            switchView.tag = indexPath.row // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            
            cell.textLabel?.text = section_cell[indexPath.section][indexPath.row]
            return cell
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
