//
//  Time.swift
//  ShuttleTrackeriOS
//
//  Created by Matt Czyr on 2/7/19.
//  Copyright © 2019 WTG. All rights reserved.
//

import Foundation

/**
 Represents a time by stripping the day/month/year from a date object and storing only the
 hour and minute.
 */
class Time: Comparable, Equatable, CustomStringConvertible {
    
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
    
    var description: String {
        let amOrPm = hour >= 12 ? "PM" : "AM"
        let formattedHour = hour % 12
        let formattedMinute = String(format: "%02d", minute)
        return  "\(formattedHour):\(formattedMinute) \(amOrPm)"
    }
    
    /**
     Returns the number of seconds that have elapsed since the given time
     - Parameter time: The time to check againsr
     - Returns: The number of seconds since the given time
    */
    func secondsSince(time: Time) -> Int {
        return time.secondsSinceBeginningOfDay - secondsSinceBeginningOfDay
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
