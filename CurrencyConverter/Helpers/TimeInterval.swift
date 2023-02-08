//
//  TimeInterval.swift
//  CurrencyConverter
//
//  Created by Asad Baidar on 06/02/2023.
//

import Foundation

public enum Seconds: Double {
    
    case inMinute = 60
    case inHour = 3600
    case inDay = 86400
    case inMonth = 2628000
    case inYear = 31557600
}

extension Double {

    public var years: Double { return self * Seconds.inYear.rawValue }
    public var months: Double { return self * Seconds.inMonth.rawValue }
    public var days: Double { return self * Seconds.inDay.rawValue }
    public var hours: Double { return self * Seconds.inHour.rawValue }
    public var minutes: Double { return self * Seconds.inMinute.rawValue }
    
    public var seconds: Double { return self / 1000 }
    public var milliseconds: Double { return self * 1000 }
}
