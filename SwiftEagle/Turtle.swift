//
//  Turtle.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/6/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Turtle {
    public let location:Point
    public let degrees:Double
        
    init(location:Point, degrees:Double) {
        self.location = location
        self.degrees = degrees
    }
    
    public func move(m:Measurement) -> Turtle {
        let radians = degrees * 2*M_PI / 360.0
        
        // Unit vector coordinates. Not a Point since this is unitless
        let rx = cos(radians)
        let ry = sin(radians)
        
        let end = location + Point(m*rx, m*ry)
        return Turtle(location: end, degrees: degrees)
    }
    
    // Sets an absolute direction
    public func point(degrees:Double) -> Turtle {
        return Turtle(location: location, degrees: degrees)
    }
    public func point(direction:Direction) -> Turtle {
        return Turtle(location: location, degrees: direction.degrees)
    }
}
