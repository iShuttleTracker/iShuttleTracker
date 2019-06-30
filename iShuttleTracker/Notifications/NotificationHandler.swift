//
//  NotificationHandler.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 2/7/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation
import UserNotifications

// The trips that the user has asked to be notified for
// Key: The trip, consisting of a starting location, destination, time to get on the shuttle, and arrival time
// Value: Keeps track of whether the 5 minute notification has been sent
var notifyForTrips: [Trip] = []

// The route IDs that the user has asked to be notified for
// Key: The route ID of shuttles that the user should be notified of the proximity of
// Value: A counter that is set to 60 after a notification is sent and counts down once
//        per second. Another notification can be sent when the counter reaches 0.
var notifyForNearbyIds: [Int:Int] = [:]

/**
 Notifies the user that they should get on the shuttle now in order to reach the
 stop they want to be at by a specified time.
 */
func handleScheduledNotifications() {
    let time = Time()
    for i in 0..<notifyForTrips.count {
        if (!notifyForTrips[i].fiveMinuteWarning && notifyForTrips[i].getOnShuttleAt.secondsSince(time: time) >= 300) {
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "Shuttle Trip"
            content.body = "You should get on the shuttle at \(notifyForTrips[i].start.name) at \(notifyForTrips[i].getOnShuttleAt)."
            content.badge = 1
            
            // Get notification trigger and request
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "ShuttleTrackerNotification", content: content, trigger: trigger)
            
            // Add notification to notification center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("Sending notification: \(content.body)")
            
            // We've given the user the 5 minute warning
            notifyForTrips[i].fiveMinuteWarning = true
        } else if (notifyForTrips[i].getOnShuttleAt.secondsSince(time: time) <= 0) {
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "Shuttle Trip"
            content.body = "You should get on the shuttle now to reach \(notifyForTrips[i].destination.name) by \(notifyForTrips[i].arriveBy)."
            content.badge = 1
            
            // Get notification trigger and request
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "ShuttleTrackerNotification", content: content, trigger: trigger)
            
            // Add notification to notification center
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("Sending notification: \(content.body)")
            
            // We've notified the user, remove it from the scheduled trips
            notifyForTrips.remove(at: i)
        }
    }
}

/**
 Notifies the user if there are any shuttles within a 100 meter radius on the route
 that the user chose to be notified for.
 */
func handleNearbyNotifications() {
    for (_, vehicle) in vehicles {
        if notifyForNearbyIds.keys.contains(vehicle.last_update.route_id) {
            // Check if a notification has already been sent for a shuttle on this route
            // in the last 60 seconds
            if (notifyForNearbyIds[vehicle.last_update.route_id]! <= 0) {
                // Send a notification when a shuttle is within 100 meters
                let distance = vehicle.last_update.point.distanceFrom(p: lastLocation!)
                if distance < 100 {
                    // Create notification content
                    let content = UNMutableNotificationContent()
                    content.title = "Nearby Shuttle"
                    content.body = "There's a shuttle on \(vehicle.last_update.route.name) route nearby."
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
    
    // Count down on each nearby notification timer that is still > 0
    for (route_id, _) in notifyForNearbyIds {
        if notifyForNearbyIds[route_id]! > 0 {
            notifyForNearbyIds[route_id]! += -1
        }
    }
}
