//
//  Trip.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 2/13/19.
//  Copyright © 2019 iShuttleTracker. All rights reserved.
//

import Foundation

/**
 Represents a trip that the user has scheduled to be notified for, specified by a starting
 point, a destination, and an arrival time. Once these three values have been selected, the
 schedule data is iterated through to find what time the user should get on the shuttle at.
 */
struct Trip {
    
    var start: Stop
    var destination: Stop
    var getOnShuttleAt: Time
    var arriveBy: Time
    var fiveMinuteWarning: Bool
    
    /**
     Initializes a new Trip from a start, destination, and arrival time.
     - Returns: A new Trip with the specified start, destination, and arrival time
     */
    init(start: Stop, destination: Stop, arriveBy: Time) {
        self.start = start
        self.destination = destination
        self.arriveBy = arriveBy
        // TODO: Once we have access to the schedule, set getOnShuttleAt to be whatever time a shuttle
        //       reaches start closest to it goes to destination at arriveBy
        self.getOnShuttleAt = Time()
        self.fiveMinuteWarning = false
    }
    
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.start == rhs.start && lhs.destination == rhs.destination
                && lhs.getOnShuttleAt == rhs.getOnShuttleAt && lhs.arriveBy == rhs.arriveBy
    }
    
}
