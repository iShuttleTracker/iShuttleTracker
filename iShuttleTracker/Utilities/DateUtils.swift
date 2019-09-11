//
//  TimeUtils.swift
//  iShuttleTracker
//
//  Created by Matt Czyr on 7/15/19.
//

import Foundation

/**
 Converts a time represented by a Date to a String.
 - Parameter date: The date to convert
 - Returns: A String of the format "yyyy-MM-dd'T'HH:mm:ss'Z'" representing the given Date time
 */
func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    return formatter.string(from: date)
}

/**
 Converts a time represented by a String to a Date.
 - Parameter date: The date to convert, in the form "yyyy-MM-dd'T'HH:mm:ss'Z'".
 - Returns: A Date object representing the given String time, or nil if the String does not represent
            a properly formatted time.
 */
func stringToDate(date: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    return formatter.date(from: date)
}

/**
 Returns the amount of time that has passed since the given Update was received.
 - Parameter update: The update to return the time since.
 - Returns: A TimeInterval (Double) representing the amount of time in seconds since the update
 was received.
 */
func secondsSince(update: Update) -> TimeInterval {
    return abs(stringToDate(date: convertFromUTC(date: update.time))!.timeIntervalSinceNow)
}

/**
 Converts the given date from UTC to the local time zone.
 - Parameter date: The UTC date to convert.
 - Returns: The date converted from UTC to the local time zone.
 */
func convertFromUTC(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    
    let dt = dateFormatter.date(from: date)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    return dateFormatter.string(from: dt!)
}
