//
//  Measurement.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public enum Measurement: Comparable {
    case Millimeter(Double)
    case Inch(Double)
    case Mil(Double) // Thousandths of an inch
    
    public var formatted: String {
        switch self {
        case .Millimeter(let v):
            return "\(v)mm"
        case .Inch(let v):
            return "\(v)in"
        case .Mil(let v):
            return "\(v)mil"
        }
    }
    
    public var millimeters:Double {
        switch self {
        case .Millimeter(let v):
            return v
        case .Inch(let v):
            return 25.4*v
        case .Mil(let v):
            return 0.0254*v
        }
    }
    
    public var value:Double {
        switch self {
        case .Millimeter(let v):
            return v
        case .Inch(let v):
            return v
        case .Mil(let v):
            return v
        }
    }
    
    public var unit:String {
        switch self {
        case .Millimeter:
            return "mm"
        case .Inch:
            return "in"
        case .Mil:
            return "mil"
        }
    }
}

// For now, these always converts to millimeters. Could make it use the type of the first argument.

public func +(a:Measurement, b:Measurement) -> Measurement {
    return Measurement.Millimeter(a.millimeters + b.millimeters)
}
public func -(a:Measurement, b:Measurement) -> Measurement {
    return Measurement.Millimeter(a.millimeters - b.millimeters)
}

public func *(m:Measurement, s:Double) -> Measurement {
    return Measurement.Millimeter(m.millimeters * s)
}
public func *(s:Double, m:Measurement) -> Measurement {
    return Measurement.Millimeter(m.millimeters * s)
}

public func ==(lhs: Measurement, rhs: Measurement) -> Bool {
    return lhs.millimeters == rhs.millimeters
}

public func <(lhs: Measurement, rhs: Measurement) -> Bool {
    return lhs.millimeters < rhs.millimeters
}
public func <=(lhs: Measurement, rhs: Measurement) -> Bool {
    return lhs.millimeters <= rhs.millimeters
}
public func >=(lhs: Measurement, rhs: Measurement) -> Bool {
    return lhs.millimeters >= rhs.millimeters
}
public func >(lhs: Measurement, rhs: Measurement) -> Bool {
    return lhs.millimeters > rhs.millimeters
}
