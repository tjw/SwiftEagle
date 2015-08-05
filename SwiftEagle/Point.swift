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
        self.y = Measurement.Millimeter(0)
    }

    public init(y:Measurement) {
        self.x = Measurement.Millimeter(0)
        self.y = y
    }
    
    public var formatted:String {
        return "(\(x.formatted) \(y.formatted))"
    }
    
    public var length: Measurement {
        let mm2 = x.millimeters*x.millimeters + y.millimeters*y.millimeters
        return Measurement.Millimeter(sqrt(mm2))
    }
}

public func +(a:Point, b:Point) -> Point {
    return Point(a.x + b.x, a.y + b.y)
}
public func -(a:Point, b:Point) -> Point {
    return Point(a.x - b.x, a.y - b.y)
}
