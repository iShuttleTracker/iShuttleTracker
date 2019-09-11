//
//  StopOnRoute.swift
//  iShuttleTracker
//
//  Created by Matt Czyr on 7/19/19.
//

import Foundation

struct StopOnRoute: Hashable {
    
    let stop: Stop
    let route: Route
    
    init(stop: Stop, route: Route) {
        self.stop = stop
        self.route = route
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(stop.latitude)
        hasher.combine(stop.longitude)
    }
    
    static func == (lhs: StopOnRoute, rhs: StopOnRoute) -> Bool {
        return lhs.stop == rhs.stop && lhs.route == rhs.route
    }
    
}
