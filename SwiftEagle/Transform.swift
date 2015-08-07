//
//  Transform.swift
//  SwiftEagle
//
//  Created by Timothy J. Wood on 8/6/15.
//  Copyright © 2015 Cocoatoa. All rights reserved.
//

import Foundation

public struct Transform {
    public let degrees:Double
    public let mirror:Bool // Flip about the y-axis, which is the only scaling that EAGLE allows.
    public let translate:Point
    
    // For the schematic side, rotations must be 0, 90, 180, 270 degrees.
    public init(degrees:Double = 0, mirror:Bool = false, translate:Point = Point(Millimeter(0), Millimeter(0))) {
        self.degrees = degrees
        self.mirror = mirror
        self.translate = translate
    }
    
    public func apply(pt:Point) -> Point {
        let radians = degrees * 2*M_PI / 360.0
        let c = cos(radians)
        let s = sin(radians)
        
        var r = Point(pt.x * c - pt.y * s, pt.x * s + pt.y * c)
        
        if mirror {
            r = Point(-r.x, r.y)
        }
        
        return r + translate
    }
}
