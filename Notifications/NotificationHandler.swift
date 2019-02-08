//
//  NotificationHandler.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 2/7/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import UserNotifications

// The times that the user should be notified to get on the shuttle
var notificationTimes: [Time] = []

// The route IDs of shuttles that the user should be notified for the proximity of
var notificationNearbyIds: [Int] = []

/**
 Notifies the user that they should get on the shuttle now in order to reach the
 stop they want to be at by a specified time.
 */
func tryNotifyTime() {
    let time = Time()
    for i in 0..<notificationTimes.count {
        if notificationTimes[i] > time {
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "Shuttle Nearby"
            content.body = "You should get on the shuttle now."
            content.badge = 1
            
            // Get notification trigger and request
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "ShuttleTrackerNotification", content: content, trigger: trigger)
            
            // Add notification to notification center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("Sending notification: \(content.body)")
            
            // We've notified the user, so remove it from the queued times
            notificationTimes.remove(at: i)
        }
    }
}

/**
 Notifies the user if there are any shuttles within a 100 meter radius on the route
 that the user chose to be notified for.
 */
func tryNotifyNearby() {
    for (id, vehicle) in vehicles {
        if notificationNearbyIds.contains(vehicle.last_update.route_id) {
            // Send a notification when a shuttle is within 100 meters
            let distance = vehicle.last_update.point.distanceFrom(p: lastLocation!)
            if distance < 100 {
                // Create notification content
                let content = UNMutableNotificationContent()
                content.title = "Nearby Shuttle"
                content.body = "There's a shuttle \(distance) meters away."
                content.badge = 1
                
                // Get notification trigger and request
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "ShuttleTrackerNotification", content: content, trigger: trigger)
                
                // Add notification to notification center
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                print("Sending notification: \(content.body)")
            }
        }
    }
}
