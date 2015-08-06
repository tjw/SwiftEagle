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
    
    public var formatted: String {
        switch self {
        case .Millimeter(let v):
            return "\(v)mm"
        case .Inch(let v):
            return "\(v)in"
        }
    }
    
    public var millimeters:Double {
        switch self {
        case .Millimeter(let v):
            return v
        case .Inch(let v):
            return 25.4*v
        }
    }
    
    public var inches:Double {
        switch self {
        case .Millimeter(let v):
            return v/25.4
        case .Inch(let v):
            return v
        }
    }
    
    public var value:Double {
        switch self {
        case .Millimeter(let v):
            return v
        case .Inch(let v):
            return v
        }
    }
    
    public var unit:String {
        switch self {
        case .Millimeter:
            return "mm"
        case .Inch:
            return "in"
        }
    }
    
    public var positive:Bool {
        return self.value > 0
    }
    
}

// These return something in the units of the first argument. This approach to measurements isn't that great, but is fairly simple.

public func +(a:Measurement, b:Measurement) -> Measurement {
    switch a {
    case .Millimeter:
        return Measurement.Millimeter(a.millimeters + b.millimeters)
    case .Inch:
        return Measurement.Inch(a.inches + b.inches)
    }
}
public func -(a:Measurement, b:Measurement) -> Measurement {
    switch a {
    case .Millimeter:
        return Measurement.Millimeter(a.millimeters - b.millimeters)
    case .Inch:
        return Measurement.Inch(a.inches - b.inches)
    }
}
public prefix func -(a:Measurement) -> Measurement {
    switch a {
    case .Millimeter:
        return Measurement.Millimeter(-a.millimeters)
    case .Inch:
        return Measurement.Inch(-a.inches)
    }
}

public func *(m:Measurement, s:Double) -> Measurement {
    switch m {
    case .Millimeter:
        return Measurement.Millimeter(m.millimeters * s)
    case .Inch:
        return Measurement.Inch(m.inches * s)
    }
}
public func *(s:Double, m:Measurement) -> Measurement {
    switch m {
    case .Millimeter:
        return Measurement.Millimeter(m.millimeters * s)
    case .Inch:
        return Measurement.Inch(m.inches * s)
    }
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
