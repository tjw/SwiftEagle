//
//  Point.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/3/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Point {
    public let x, y: Measurement
    
    public init(_ x:Measurement, _ y: Measurement) {
        self.x = x
        self.y = y
    }
    
    public init(x:Measurement) {
        self.x = x
        self.y = Measurement(0, x.unit)
    }

    public init(y:Measurement) {
        self.x = Measurement(0, y.unit)
        self.y = y
    }
        
    public var length: Measurement {
        // Get components in the same units, if they aren't already.
        let xv = x
        let yv = y.to(x.unit)
        
        // Return the distance in the same units as the original x component
        let d2 = xv.value*xv.value + yv.value * yv.value
        return Measurement(sqrt(d2), x.unit)
    }
    
    public func midPoint(pt:Point) -> Point {
        let midX = 0.5 * (x + pt.x)
        let midY = 0.5 * (y + pt.y)
        return Point(midX, midY)
    }
}

extension Point: MeasurementConvertible {
    public func to(toUnit: MeasurementUnit) -> Point {
        return Point(x.to(toUnit), y.to(toUnit))
    }
}

public func +(a:Point, b:Point) -> Point {
    return Point(a.x + b.x, a.y + b.y)
}
public func -(a:Point, b:Point) -> Point {
    return Point(a.x - b.x, a.y - b.y)
}

public func +(a:Point, b:Size) -> Point {
    return Point(a.x + b.w, a.y + b.h)
}
public func -(a:Point, b:Size) -> Point {
    return Point(a.x - b.w, a.y - b.h)
}
