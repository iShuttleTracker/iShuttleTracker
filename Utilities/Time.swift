//
//  Time.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 2/7/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation

class Time: Comparable, Equatable {
    
    var hour : Int
    var minute: Int
    private let secondsSinceBeginningOfDay: Int
    
    /**
     Creates a Time from the current Date.
     - Returns: A new Time with the current hour, minute, and seconds
    */
    convenience init() {
        self.init(date: Date())
    }
    
    /**
     Creates a Time from a Date.
     - Returns: A new Time with the hours, minutes, and seconds from the Date
     */
    init(date: Date) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        // Calculate the seconds since the beggining of the day
        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60
        secondsSinceBeginningOfDay = dateSeconds
        hour = dateComponents.hour!
        minute = dateComponents.minute!
    }
    
    /**
     Creates a Time from an hour and a minute.
     - Parameters:
       - hour: The hour for the new Time
       - minute: The minute for the new Time
     - Returns: A new Time with the specified hours and minutes.
     */
    init(_ hour: Int, _ minute: Int) {
        // Calculate the seconds since the beggining of the day
        let dateSeconds = hour * 3600 + minute * 60
        secondsSinceBeginningOfDay = dateSeconds
        self.hour = hour
        self.minute = minute
    }
    
    /**
     Equals operator for two Time objects.
     - Parameters:
       - lhs: The left side Time
       - rhs: The right side Time
     - Returns: True if the left side Time's hours, minutes, and seconds are equal
                to the right side's hours, minutes, and seconds.
     */
    static func == (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay == rhs.secondsSinceBeginningOfDay
    }
    
    /**
     Less than operator for two Time objects.
     - Parameters:
     - lhs: The left side Time
     - rhs: The right side Time
     - Returns: True if the left side Time's hours, minutes, and seconds represent
                a time that comes before the right side Time.
     */
    static func < (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay < rhs.secondsSinceBeginningOfDay
    }
    
    /**
     Greater than operator for two Time objects.
     - Parameters:
     - lhs: The left side Time
     - rhs: The right side Time
     - Returns: True if the left side Time's hours, minutes, and seconds represent
     a time that comes after the right side Time.
     */
    static func > (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay > rhs.secondsSinceBeginningOfDay
    }
    
    /**
     Less than or equal to operator for two Time objects.
     - Parameters:
     - lhs: The left side Time
     - rhs: The right side Time
     - Returns: True if the left side Time's hours, minutes, and seconds represent
     a time that comes before or is equal to the right side Time.
     */
    static func <= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay <= rhs.secondsSinceBeginningOfDay
    }
    
    /**
     Greater than or equal to operator for two Time objects.
     - Parameters:
     - lhs: The left side Time
     - rhs: The right side Time
     - Returns: True if the left side Time's hours, minutes, and seconds represent
     a time that comes after or is equal to the right side Time.
     */
    static func >= (lhs: Time, rhs: Time) -> Bool {
        return lhs.secondsSinceBeginningOfDay >= rhs.secondsSinceBeginningOfDay
    }

}
