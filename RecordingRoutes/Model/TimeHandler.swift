//
//  TimeHandler.swift
//  RecordingRoutes
//
//  Created by Adrian on 04/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import Foundation

class TimeHandler {
    
    static func calculateHoursBetweenDates(initialDate : Date, finalDate : Date) -> String {
        let difference = finalDate.timeIntervalSince(initialDate)
        return (stringFromTimeInterval(interval: difference) + "  hh:mm:ss")
    }
    
    static func stringFromTimeInterval(interval : TimeInterval) -> String {
        let time = NSInteger(interval)
        //let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
}
