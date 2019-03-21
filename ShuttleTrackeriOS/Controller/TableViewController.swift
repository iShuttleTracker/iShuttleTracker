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
    
    //private var route_cell = []
    private var notification_cell = ["Enable nearby notifications", "Enable scheduled notifications"]
    //private var nearbyNotification_cell = []
    //private var scheduledNotification_cell = []
    
    //private var section_cell = [route_cell, notification_cell, nearbyNofication_cell, scheduledNotification_cell]
    


    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = indexPath.section
        if sections[currentSection] == "SCHEDULED TRIP NOTIFICATIONS" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddSchedule", for: indexPath)
            cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Switches", for: indexPath)
            cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
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
